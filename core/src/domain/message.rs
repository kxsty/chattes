use serde::{Deserialize, Serialize};
use std::{borrow::Borrow, cmp::Ordering};

use crate::domain::{attachment::AttachmentModel, datetime::DateTimeModel, id::IdModel};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MessageModel {
    pub id: IdModel,
    pub created_at: DateTimeModel,
    pub updated_at: DateTimeModel,
    pub text: String,
    pub attachments: Vec<AttachmentModel>,
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
