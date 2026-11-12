use serde::{Deserialize, Serialize};
use std::{borrow::Borrow, cmp::Ordering};

use ferroid::serde::snow_as_base32;

use crate::domain::{Id, attachment::AttachmentModel, datetime::Timestamp};

/// Owned by Chat
#[derive(Serialize, Deserialize)]
pub struct MessageModel {
    #[serde(with = "snow_as_base32")]
    pub id: Id,
    pub text: String,
    pub attachments: Vec<AttachmentModel>,
    pub created_at: Timestamp,
    pub updated_at: Timestamp,
}

#[allow(clippy::non_canonical_partial_ord_impl)]
impl PartialOrd for MessageModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.id.cmp(&other.id))
    }
}

impl Ord for MessageModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}

impl PartialEq for MessageModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}

impl Eq for MessageModel {}

impl Borrow<Id> for MessageModel {
    fn borrow(&self) -> &Id {
        &self.id
    }
}
