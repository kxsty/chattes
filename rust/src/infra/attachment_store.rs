use crate::domain::model::{AttachmentModel, Id, Timestamp};
use crate::infra::error::Result;
use crate::infra::fs_utils::{copy_file, ensure_parents_exist, remove_parents_while};
use std::ffi::OsStr;
use std::path::{Path, PathBuf};

pub struct AttachmentStore {
    chats_path: PathBuf,
}

impl AttachmentStore {
    pub const fn new(chats_path: PathBuf) -> Self {
        Self { chats_path }
    }

    pub fn insert(&self, chat_id: Id, id: Id, source: &Path) -> Result<AttachmentModel> {
        let file_name = source
            .file_name()
            .and_then(OsStr::to_str)
            .unwrap_or("")
            .to_owned();

        let path = ensure_parents_exist(self.attachment_file_path(&chat_id, &id, &file_name))?;

        let size = copy_file(&source, &path)?;

        let response = AttachmentModel {
            id,
            path,
            file_name,
            size,
        };

        Ok(response)
    }

    pub fn delete(&self, attachment: AttachmentModel) -> Result<bool> {
        if !attachment.path.try_exists()? {
            return Ok(false);
        }

        Ok(remove_parents_while(attachment.path, |p| {
            p != self.chats_path
        })?)
    }

    fn attachment_file_path(&self, chat_id: &Id, id: &Id, file_name: &str) -> PathBuf {
        const INNER_DIR: &str = "attachments";

        let chat_id = chat_id.to_string();

        let sent_at = Timestamp::from(id);
        let id = id.to_string();

        let year = sent_at.year().to_string();
        let month = sent_at.month().to_string();
        let day = sent_at.day().to_string();

        let extension = Path::new(file_name).extension().unwrap_or(OsStr::new(""));

        let mut path = PathBuf::with_capacity(
            self.chats_path.to_str().unwrap_or("").len()
                + 1
                + chat_id.len()
                + 1
                + year.len()
                + 1
                + month.len()
                + 1
                + day.len()
                + 1
                + INNER_DIR.len()
                + 1
                + id.len()
                + 1
                + extension.len(),
        );

        path.push(&self.chats_path);
        path.push(chat_id);
        path.push(year);
        path.push(month);
        path.push(day);
        path.push(INNER_DIR);
        path.push(id);
        path.set_extension(extension);

        path
    }
}
