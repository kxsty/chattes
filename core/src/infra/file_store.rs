use std::path::{Path, PathBuf};
use std::sync::Arc;
use std::{fs, io};

use sqlx::SqlitePool;

use crate::domain::file::FileModel;
use crate::domain::id::IdModel;
use crate::infra::error::Result;
use crate::infra::fs_utils::copy_and_hash_file;

pub struct FileStore {
    db: SqlitePool,
    dir_path: Arc<Path>,
}

impl FileStore {
    pub fn new(db: SqlitePool, dir_path: Arc<Path>) -> Self {
        debug_assert!(dir_path.is_dir());
        debug_assert!(dir_path.exists());

        Self { db, dir_path }
    }

    pub async fn insert<P>(&self, id: IdModel, source_path: P) -> Result<FileModel>
    where
        P: AsRef<Path>,
    {
        let (size, path) = self.copy_and_hash_file(source_path)?;
        let size = size as u64;

        // Return existing record if path violates path's unique constraints
        let row = sqlx::query_as!(
            Row,
            "\
INSERT INTO files (id, path, size) VALUES (?, ?, ?) \
ON CONFLICT(path) DO UPDATE SET path = excluded.path \
RETURNING *",
            id,
            path.to_string_lossy(),
            i64::try_from(size).expect("Size should be less than i64::MAX")
        )
        .fetch_one(&self.db)
        .await?;

        let file = row.into_model();

        Ok(file)
    }

    pub async fn delete(&self, id: IdModel) -> Result<Option<FileModel>> {
        let row = sqlx::query_as!(Row, "DELETE FROM files WHERE id = ? RETURNING *", id)
            .fetch_optional(&self.db)
            .await?;

        let Some(row) = row else {
            return Ok(None);
        };

        let file = row.into_model();
        fs::remove_file(&file.path)?;

        Ok(Some(file))
    }

    fn copy_and_hash_file<P>(&self, source_path: P) -> io::Result<(usize, PathBuf)>
    where
        P: AsRef<Path>,
    {
        copy_and_hash_file(source_path, &self.dir_path)
    }
}

struct Row {
    id: IdModel,
    path: String,
    size: i64,
}

impl Row {
    fn into_model(self) -> FileModel {
        FileModel {
            id: self.id,
            path: PathBuf::from(self.path),
            size: u64::try_from(self.size).expect("Size should be more than zero"),
        }
    }
}
