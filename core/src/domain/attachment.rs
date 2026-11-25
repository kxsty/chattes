use std::path::PathBuf;

use serde::{Deserialize, Serialize};

use crate::domain::id::IdModel;

/// Owned by Message
#[derive(Serialize, Deserialize)]
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
