use std::cmp::Ordering;

use ferroid::serde::snow_as_base32;
use serde::{Deserialize, Serialize};

use crate::domain::{Id, message::MessageModel};

#[derive(Serialize, Deserialize)]
pub struct ChatModel {
    #[serde(with = "snow_as_base32")]
    pub id: Id,
    pub name: String,
    pub last_message: Option<MessageModel>,
}

impl PartialEq for ChatModel {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

impl Eq for ChatModel {}

impl PartialOrd for ChatModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for ChatModel {
    fn cmp(&self, other: &Self) -> Ordering {
        match (&self.last_message, &other.last_message) {
            (None, None) => Ordering::Equal,
            (None, Some(_)) => Ordering::Greater,
            (Some(_), None) => Ordering::Less,
            (Some(a), Some(b)) => a.cmp(b),
        }
        .then(self.id.cmp(&other.id))
    }
}
