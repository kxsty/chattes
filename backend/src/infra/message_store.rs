use crate::domain::model::{AttachmentModel, Day, Id, MessageModel, Month, Timestamp, Year};
use crate::infra::error::Error::NotFound;
use crate::infra::error::Result;
use crate::infra::fs_utils::{
    deserialize_from_file, ensure_parents_exist, remove_parents_while, serialize_to_file,
    DirEntryNames,
};
use chrono::Utc;
use cmp::Reverse;
use std::cmp;
use std::collections::BTreeSet;
use std::path::PathBuf;
use std::sync::Mutex;

pub struct MessageStore {
    chats_path: PathBuf,
    mutex: Mutex<()>,
}
impl MessageStore {
    pub fn new(chats_path: PathBuf) -> Self {
        Self {
            chats_path,
            mutex: Mutex::new(()),
        }
    }

    pub fn select(
        &self,
        chat_id: &Id,
        id_cursor: Option<Id>,
        limit: usize,
        desc: bool,
    ) -> Result<Vec<MessageModel>> {
        if desc {
            self.select_desc(chat_id, id_cursor, limit)
        } else {
            self.select_asc(chat_id, id_cursor, limit)
        }
    }

    pub fn find(&self, chat_id: &Id, id: &Id) -> Result<Option<MessageModel>> {
        let path = self.messages_fpath(&chat_id, &id);

        let mut messages: Vec<MessageModel> = deserialize_from_file(&path)?.unwrap_or_default();
        let Ok(index) = messages.binary_search_by(|m| m.id.cmp(&id)) else {
            return Ok(None);
        };

        Ok(Some(messages.swap_remove(index)))
    }

    pub fn insert(
        &self,
        chat_id: &Id,
        id: Id,
        sent_at: Timestamp,
        text: String,
        attachments: Vec<AttachmentModel>,
    ) -> Result<MessageModel> {
        let path = ensure_parents_exist(self.messages_fpath(&chat_id, &id))?;

        let message = MessageModel {
            id,
            text,
            attachments,
            sent_at: sent_at.clone(),
            updated_at: sent_at,
        };

        let _guard = self.mutex.lock();

        let mut messages: BTreeSet<MessageModel> =
            deserialize_from_file(&path)?.unwrap_or_default();

        let existed = !messages.insert(message);
        debug_assert_eq!(existed, false);

        serialize_to_file(&path, &messages)?;

        let message = messages.take(&id).expect("Message should exist in the set");

        Ok(message)
    }

    pub fn update(&self, chat_id: &Id, id: &Id, text: Option<String>) -> Result<MessageModel> {
        let path = ensure_parents_exist(self.messages_fpath(&chat_id, &id))?;

        let _guard = self.mutex.lock();

        let mut messages: Vec<MessageModel> = deserialize_from_file(&path)?.unwrap_or_default();
        let index = messages
            .binary_search_by(|m| m.id.cmp(&id))
            .map_err(|_| NotFound("Message not found".into()))?;

        let message = &mut messages[index];

        let mut updated = false;
        if let Some(new_text) = text {
            if message.text != new_text {
                message.text = new_text;
                updated = true;
            }
        }

        message.updated_at = Timestamp::new(Utc::now());

        if updated {
            serialize_to_file(&path, &messages)?;
        }

        Ok(messages.swap_remove(index))
    }

    pub fn delete(&self, chat_id: &Id, id: Id) -> Result<Option<MessageModel>> {
        let path = self.messages_fpath(&chat_id, &id);
        if !path.try_exists()? {
            return Ok(None);
        }

        let _guard = self.mutex.lock();

        let mut messages: BTreeSet<MessageModel> =
            deserialize_from_file(&path)?.unwrap_or_default();
        let Some(message) = messages.take(&id) else {
            return Ok(None);
        };

        if messages.is_empty() {
            remove_parents_while(path, |p| p != self.chats_path)?;
        } else {
            serialize_to_file(&path, &messages)?;
        }

        Ok(Some(message))
    }

    fn select_asc(
        &self,
        chat_id: &Id,
        id_cursor: Option<Id>,
        take: usize,
    ) -> Result<Vec<MessageModel>> {
        let mut result = Vec::with_capacity(take);
        if take == 0 {
            return Ok(result);
        }

        let id_cursor = id_cursor.unwrap_or_else(|| Id::from_raw(u64::MIN));
        let date_cursor = Timestamp::from(&id_cursor);

        let mut path = self.chats_path.join(chat_id.to_string());

        let mut years = Vec::new();
        let mut months = Vec::new();
        let mut days = Vec::new();

        let _guard = self.mutex.lock();

        for year in DirEntryNames::<Year>::new(&path)? {
            let year = year?;
            years.push(year);
        }
        years.sort_unstable();

        for year in years.into_iter() {
            if year < date_cursor.year() {
                continue;
            }
            path.push(year.to_string());

            months.clear();
            for month in DirEntryNames::<Month>::new(&path)? {
                let month = month?;
                months.push(month);
            }
            months.sort_unstable();

            for month in months.iter() {
                if year == date_cursor.year() && *month < date_cursor.month() {
                    continue;
                }
                path.push(month.to_string());

                days.clear();
                for day in DirEntryNames::<Day>::new(&path)? {
                    let day = day?;
                    days.push(day);
                }
                days.sort_unstable();

                for day in days.iter() {
                    if year == date_cursor.year()
                        && *month == date_cursor.month()
                        && *day < date_cursor.day()
                    {
                        continue;
                    }
                    path.push(day.to_string());
                    path.push(Self::messages_fname(year, *month, *day));

                    let messages: Vec<MessageModel> =
                        deserialize_from_file(&path)?.unwrap_or_default();
                    debug_assert!(messages.is_sorted());

                    for message in messages.into_iter() {
                        if message.id <= id_cursor {
                            continue;
                        }

                        result.push(message);
                        if result.len() >= take {
                            return Ok(result);
                        }
                    }

                    path.pop(); // Pop file
                    path.pop(); // Pop day
                }

                path.pop(); // Pop month
            }

            path.pop(); // Pop year
        }

        Ok(result)
    }

    fn select_desc(
        &self,
        chat_id: &Id,
        id_cursor: Option<Id>,
        take: usize,
    ) -> Result<Vec<MessageModel>> {
        let mut result = Vec::with_capacity(take);
        if take == 0 {
            return Ok(result);
        }

        let id_cursor = id_cursor.unwrap_or_else(|| Id::from_raw(u64::MAX));
        let date_cursor = Timestamp::from(&id_cursor);

        let mut path = self.chats_path.join(chat_id.to_string());

        let mut years = Vec::new();
        let mut months = Vec::new();
        let mut days = Vec::new();

        let _guard = self.mutex.lock();

        for year in DirEntryNames::<Year>::new(&path)? {
            let year = year?;
            years.push(year);
        }
        years.sort_unstable_by_key(|&y| Reverse(y));

        for year in years.into_iter() {
            if year > date_cursor.year() {
                continue;
            }
            path.push(year.to_string());

            months.clear();
            for month in DirEntryNames::<Month>::new(&path)? {
                let month = month?;
                months.push(month);
            }
            months.sort_unstable_by_key(|&m| Reverse(m));

            for month in months.iter() {
                if year == date_cursor.year() && *month > date_cursor.month() {
                    continue;
                }
                path.push(month.to_string());

                days.clear();
                for day in DirEntryNames::<Day>::new(&path)? {
                    let day = day?;
                    days.push(day);
                }
                days.sort_unstable_by_key(|&d| Reverse(d));

                for day in days.iter() {
                    if year == date_cursor.year()
                        && *month == date_cursor.month()
                        && *day > date_cursor.day()
                    {
                        continue;
                    }
                    path.push(day.to_string());
                    path.push(Self::messages_fname(year, *month, *day));

                    let messages: Vec<MessageModel> =
                        deserialize_from_file(&path)?.unwrap_or_default();
                    debug_assert!(messages.is_sorted());

                    for message in messages.into_iter().rev() {
                        if message.id >= id_cursor {
                            continue;
                        }

                        result.push(message);
                        if result.len() >= take {
                            return Ok(result);
                        }
                    }

                    path.pop(); // Pop file
                    path.pop(); // Pop day
                }

                path.pop(); // Pop month
            }

            path.pop(); // Pop year
        }

        Ok(result)
    }

    fn messages_fpath(&self, chat_id: &Id, id: &Id) -> PathBuf {
        let chat_id = chat_id.to_string();
        let sent_at = Timestamp::from(id);

        let year = sent_at.year();
        let month = sent_at.month();
        let day = sent_at.day();

        let file_name = Self::messages_fname(year, month, day);

        let year_s = year.to_string();
        let month_s = month.to_string();
        let day_s = day.to_string();

        let mut path = PathBuf::with_capacity(
            self.chats_path.to_str().unwrap_or_default().len()
                + 1
                + year_s.len()
                + 1
                + month_s.len()
                + 1
                + day_s.len()
                + 1
                + file_name.len(),
        );

        path.push(&self.chats_path);
        path.push(chat_id);
        path.push(year_s);
        path.push(month_s);
        path.push(day_s);
        path.push(file_name);

        path
    }

    fn messages_fname(year: Year, month: Month, day: Day) -> String {
        format!("{}-{}-{}.yaml", year, month, day)
    }
}
