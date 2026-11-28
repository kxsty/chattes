use std::cmp::Ordering;

use serde::{Deserialize, Serialize};

use crate::domain::{file::FileModel, id::IdModel};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AttachmentModel {
    pub id: IdModel,
    pub file: FileModel,
    pub name: String,
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
