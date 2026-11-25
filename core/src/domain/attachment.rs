use std::{cmp::Ordering, path::PathBuf};

use serde::{Deserialize, Serialize};

use crate::domain::id::IdModel;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AttachmentModel {
    pub id: IdModel,
    pub path: PathBuf,
    pub file_name: String,
    pub size: u64,
}

impl PartialEq for AttachmentModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}

impl Eq for AttachmentModel {}

impl PartialOrd for AttachmentModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for AttachmentModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}
