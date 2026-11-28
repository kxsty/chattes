use std::path::Path;
use std::sync::Arc;

use crate::domain::file::FileModel;
use crate::domain::id::IdModel;
use crate::infra::error::Result;
use crate::infra::fs_utils::{copy_and_hash_file, remove_parents_while};

pub struct FileStore {
    dir_path: Arc<Path>,
}

impl FileStore {
    pub fn new(dir_path: Arc<Path>) -> Self {
        debug_assert!(dir_path.is_dir());
        debug_assert!(dir_path.exists());

        Self { dir_path }
    }

    pub fn insert<P>(&self, id: IdModel, source_path: P) -> Result<FileModel>
    where
        P: AsRef<Path>,
    {
        let (size, path) = copy_and_hash_file(source_path, &self.dir_path)?;
        let size = size as u64;

        let response = FileModel { id, path, size };

        Ok(response)
    }

    pub fn delete(&self, file: FileModel) -> Result<bool> {
        if !file.path.try_exists()? {
            return Ok(false);
        }

        Ok(remove_parents_while(file.path, |p| {
            p != self.dir_path.as_ref()
        })?)
    }
}
