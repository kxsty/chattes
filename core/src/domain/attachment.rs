use std::path::PathBuf;

use ferroid::serde::snow_as_base32;
use serde::{Deserialize, Serialize};

use crate::domain::IdModel;

/// Owned by Message
#[derive(Serialize, Deserialize)]
pub struct AttachmentModel {
    #[serde(with = "snow_as_base32")]
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
