use std::path::{Path, PathBuf};
use std::sync::Arc;

use crate::domain::attachment::AttachmentModel;
use crate::domain::id::IdModel;
use crate::infra::error::Result;
use crate::infra::fs_utils::{copy_and_hash_file, ensure_exists, remove_parents_while};

pub struct AttachmentStore {
    chats_path: Arc<Path>,
}

impl AttachmentStore {
    pub const fn new(chats_path: Arc<Path>) -> Self {
        Self { chats_path }
    }

    pub fn insert(&self, chat_id: IdModel, id: IdModel, source: &Path) -> Result<AttachmentModel> {
        let file_name = source
            .file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .into_owned();

        let dir_path = ensure_exists(self.attachment_dir_path(chat_id))?;

        let (size, path) = copy_and_hash_file(source, dir_path)?;

        let response = AttachmentModel {
            id,
            path,
            file_name,
            size: size as u64,
        };

        Ok(response)
    }

    pub fn delete(&self, attachment: AttachmentModel) -> Result<bool> {
        if !attachment.path.try_exists()? {
            return Ok(false);
        }

        Ok(remove_parents_while(attachment.path, |p| {
            p != self.chats_path.as_ref()
        })?)
    }

    fn attachment_dir_path(&self, chat_id: IdModel) -> PathBuf {
        const INNER_DIR: &str = "attachments";

        let chat_id = chat_id.to_string();

        let mut path = PathBuf::with_capacity(
            self.chats_path.to_string_lossy().len() + 1 + chat_id.len() + 1 + INNER_DIR.len(),
        );

        path.push(&self.chats_path);
        path.push(chat_id);
        path.push(INNER_DIR);

        path
    }
}
