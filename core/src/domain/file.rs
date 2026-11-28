use std::{cmp::Ordering, path::PathBuf};

use serde::{Deserialize, Serialize};

use crate::domain::id::IdModel;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FileModel {
    pub id: IdModel,
    pub path: PathBuf,
    pub size: u64,
}

impl PartialEq for FileModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}

impl Eq for FileModel {}

impl PartialOrd for FileModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for FileModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}
