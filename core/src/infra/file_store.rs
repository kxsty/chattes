use std::path::{Path, PathBuf};
use std::sync::Arc;

use crate::domain::file::FileModel;
use crate::domain::id::IdModel;
use crate::infra::error::Result;
use crate::infra::fs_utils::{copy_and_hash_file, ensure_exists, remove_parents_while};

pub struct FileStore {
    chats_path: Arc<Path>,
}

impl FileStore {
    pub fn new(chats_path: Arc<Path>) -> Self {
        debug_assert!(chats_path.is_dir());
        debug_assert!(chats_path.exists());

        Self { chats_path }
    }

    pub fn insert<P>(&self, chat_id: IdModel, id: IdModel, source_path: P) -> Result<FileModel>
    where
        P: AsRef<Path>,
    {
        let dir_path = ensure_exists(self.file_dir_path(chat_id))?;

        let (size, path) = copy_and_hash_file(source_path, dir_path)?;
        let size = size as u64;

        let response = FileModel { id, path, size };

        Ok(response)
    }

    pub fn delete(&self, file: FileModel) -> Result<bool> {
        if !file.path.try_exists()? {
            return Ok(false);
        }

        Ok(remove_parents_while(file.path, |p| {
            p != self.chats_path.as_ref()
        })?)
    }

    fn file_dir_path(&self, chat_id: IdModel) -> PathBuf {
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
