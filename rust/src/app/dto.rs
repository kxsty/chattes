use crate::domain;
use chrono::{DateTime, Utc};
use domain::model;
use flutter_rust_bridge::frb;

#[frb(type_64bit_int)]
pub struct Chat {
    pub id: u64,
    pub name: String,
    pub last_message: Option<Message>,
}
impl From<model::ChatModel> for Chat {
    fn from(value: model::ChatModel) -> Self {
        Self {
            id: value.id.to_raw(),
            name: value.name,
            last_message: value.last_message.map(Message::from),
        }
    }
}

pub struct ListChats {
    pub limit: u32,
    pub desc: bool,
}

#[frb(type_64bit_int)]
pub struct GetChat {
    pub id: u64,
}

pub struct PostChat {
    pub name: String,
}

#[frb(type_64bit_int)]
pub struct PatchChat {
    pub id: u64,
    pub name: Option<String>,
}

#[frb(type_64bit_int)]
pub struct DeleteChat {
    pub id: u64,
}

#[frb(type_64bit_int)]
pub struct Message {
    pub id: u64,
    pub sent_at: DateTime<Utc>,
    pub text: String,
    pub attachments: Vec<Attachment>,
}
impl From<model::MessageModel> for Message {
    fn from(value: model::MessageModel) -> Self {
        Self {
            id: value.id.to_raw(),
            sent_at: value.sent_at.into(),
            text: value.text,
            attachments: value
                .attachments
                .into_iter()
                .map(Attachment::from)
                .collect(),
        }
    }
}

#[frb(type_64bit_int)]
pub struct ListMessages {
    pub chat_id: u64,
    pub id: Option<u64>,
    pub limit: u32,
    pub desc: bool,
}

#[frb(type_64bit_int)]
pub struct GetMessage {
    pub chat_id: u64,
    pub id: u64,
}

#[frb(type_64bit_int)]
pub struct PostMessage {
    pub chat_id: u64,
    pub text: String,
    pub attachments: Vec<PostAttachment>,
}

#[frb(type_64bit_int)]
pub struct PatchMessage {
    pub chat_id: u64,
    pub id: u64,
    pub text: Option<String>,
}

#[frb(type_64bit_int)]
pub struct DeleteMessage {
    pub chat_id: u64,
    pub id: u64,
}

pub struct Attachment {
    pub path: String,
    pub file_name: String,
}
impl From<model::AttachmentModel> for Attachment {
    fn from(value: model::AttachmentModel) -> Self {
        Self {
            path: value.path.to_str().unwrap_or("").to_owned(),
            file_name: value.file_name,
        }
    }
}

pub struct PostAttachment {
    pub path: String,
}

#[frb(type_64bit_int)]
pub struct DeleteAttachment {
    pub chat_id: u64,
    pub message_id: u64,
    pub id: u64,
}
