use crate::domain::model::{ChatModel, Id, MessageModel};
use crate::infra::error::Result;
use crate::infra::fs_utils::{
    deserialize_from_file, ensure_parents_exist, serialize_to_file, DirEntryNames,
};
use std::cmp::Ordering;
use std::fs;
use std::path::PathBuf;

pub struct ChatStore {
    path: PathBuf,
}
impl ChatStore {
    pub fn new(app_path: PathBuf) -> Result<Self> {
        let path = app_path.join("chats");
        fs::create_dir_all(&path)?;

        Ok(Self { path })
    }

    pub fn select(
        &self,
        last_message_id_cursor: Option<Id>,
        desc: bool,
        limit: usize,
    ) -> Result<Vec<ChatModel>> {
        let last_message_id_cursor = last_message_id_cursor.unwrap_or_else(|| {
            if desc {
                Id::from_raw(u64::MAX)
            } else {
                Id::from_raw(u64::MIN)
            }
        });

        let ordering = if desc {
            Ordering::Less
        } else {
            Ordering::Greater
        };

        let mut chats = Vec::with_capacity(limit);

        for id in DirEntryNames::<Id>::new(&self.path)? {
            let id = id?;

            let Some(chat) = self.find(&id)? else {
                continue;
            };

            let Some(last_message) = &chat.last_message else {
                chats.push(chat);
                continue;
            };

            if last_message.id.cmp(&last_message_id_cursor) == ordering {
                chats.push(chat);
            }
        }

        if desc {
            chats.sort_unstable_by(|a, b| b.cmp(a));
        } else {
            chats.sort_unstable_by(|a, b| a.cmp(b));
        }

        chats.truncate(limit);

        Ok(chats)
    }

    pub fn find(&self, id: &Id) -> Result<Option<ChatModel>> {
        let path = self.chat_fpath(id);

        deserialize_from_file(path)
    }

    pub fn insert(
        &self,
        id: Id,
        name: String,
        last_message: Option<MessageModel>,
    ) -> Result<ChatModel> {
        let path = ensure_parents_exist(self.chat_fpath(&id))?;

        let chat = ChatModel {
            id,
            name,
            last_message,
        };

        serialize_to_file(path, &chat)?;

        Ok(chat)
    }

    pub fn update(
        &self,
        id: &Id,
        name: Option<String>,
        last_message: Option<Option<MessageModel>>,
    ) -> Result<Option<ChatModel>> {
        let path = self.chat_fpath(id);

        let Some(mut chat): Option<ChatModel> = deserialize_from_file(&path)? else {
            return Ok(None);
        };

        let mut updated = false;
        if let Some(name) = name {
            if name != chat.name {
                chat.name = name;
                updated = true;
            }
        }

        if let Some(last_message) = last_message {
            if chat.last_message != last_message {
                chat.last_message = last_message;
                updated = true;
            }
        }

        if updated {
            serialize_to_file(&path, &chat)?;
        }

        Ok(Some(chat))
    }

    pub fn delete(&self, id: &Id) -> Result<bool> {
        let path = self.chat_fpath(id);
        if !path.try_exists()? {
            return Ok(false);
        };

        if let Some(parent) = path.parent() {
            fs::remove_dir_all(parent)?;
        }

        Ok(true)
    }

    pub fn exists(&self, id: &Id) -> Result<bool> {
        Ok(self.chat_fpath(id).try_exists()?)
    }

    fn chat_fpath(&self, id: &Id) -> PathBuf {
        self.path.join(id.to_string()).join("data.yaml")
    }
}
