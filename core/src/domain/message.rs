use serde::{Deserialize, Serialize};
use std::{borrow::Borrow, cmp::Ordering};

use ferroid::serde::snow_as_base32;

use crate::domain::{IdModel, attachment::AttachmentModel, datetime::Timestamp};

/// Owned by Chat
#[derive(Serialize, Deserialize)]
pub struct MessageModel {
    #[serde(with = "snow_as_base32")]
    pub id: IdModel,
    pub text: String,
    pub attachments: Vec<AttachmentModel>,
    pub created_at: Timestamp,
    pub updated_at: Timestamp,
}

impl PartialEq for MessageModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}

impl Eq for MessageModel {}

impl PartialOrd for MessageModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for MessageModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}

impl Borrow<IdModel> for MessageModel {
    fn borrow(&self) -> &IdModel {
        &self.id
    }
}
