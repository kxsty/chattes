use chrono::{DateTime, Utc};
use flutter_rust_bridge::frb;

use crate::domain::{attachment::AttachmentModel, chat::ChatModel, message::MessageModel};

#[frb(type_64bit_int)]
#[frb(dart_code = "
int compareTo(Chat other) {
    if (lastMessage == null && other.lastMessage == null) {
        return 0;
    }
    if (lastMessage == null) {
        return 1;
    }
    if (other.lastMessage == null) {
        return -1;
    }

    final lastMessageCmp = lastMessage!.compareTo(other.lastMessage!);
    if (lastMessageCmp != 0) {
        return lastMessageCmp;
    }

    return id.compareTo(other.id);
}

Chat copyWith({int? id, String? name, Message? lastMessage}) {
    return Chat(
        id: id ?? this.id,
        name: name ?? this.name,
        lastMessage: lastMessage ?? this.lastMessage,
    );
}
")]
pub struct Chat {
    pub id: u64,
    pub name: String,
    pub last_message: Option<Message>,
}
impl From<ChatModel> for Chat {
    fn from(value: ChatModel) -> Self {
        Self {
            id: value.id.to_raw(),
            name: value.name,
            last_message: value.last_message.map(Message::from),
        }
    }
}

#[frb(type_64bit_int)]
#[derive(Clone, Copy)]
pub struct ListChats {
    pub last_message_id_cursor: Option<u64>,
    pub limit: u32,
    pub desc: bool,
}

#[frb(type_64bit_int)]
#[derive(Clone, Copy)]
pub struct ReadChat {
    pub id: u64,
}

pub struct CreateChat {
    pub name: String,
}

#[frb(type_64bit_int)]
pub struct UpdateChat {
    pub id: u64,
    pub name: Option<String>,
}

#[frb(type_64bit_int)]
#[derive(Clone, Copy)]
pub struct DeleteChat {
    pub id: u64,
}

#[frb(type_64bit_int)]
#[frb(dart_code = "
int compareTo(Message other) {
    return id.compareTo(other.id);
}
")]
pub struct Message {
    pub id: u64,
    pub created_at: DateTime<Utc>,
    pub text: String,
    pub attachments: Vec<Attachment>,
}
impl From<MessageModel> for Message {
    fn from(value: MessageModel) -> Self {
        Self {
            id: value.id.to_raw(),
            created_at: value.created_at.into(),
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
#[derive(Clone, Copy)]
pub struct ListMessages {
    pub chat_id: u64,
    pub id_cursor: Option<u64>,
    pub limit: u32,
    pub desc: bool,
}

#[frb(type_64bit_int)]
#[derive(Clone, Copy)]
pub struct ReadMessage {
    pub chat_id: u64,
    pub id: u64,
}

#[frb(type_64bit_int)]
pub struct CreateMessage {
    pub chat_id: u64,
    pub text: String,
    pub attachments: Vec<CreateAttachment>,
}

#[frb(type_64bit_int)]
pub struct UpdateMessage {
    pub chat_id: u64,
    pub id: u64,
    pub text: Option<String>,
}

#[frb(type_64bit_int)]
#[derive(Clone, Copy)]
pub struct DeleteMessage {
    pub chat_id: u64,
    pub id: u64,
}

pub struct Attachment {
    pub path: String,
    pub file_name: String,
}
impl From<AttachmentModel> for Attachment {
    fn from(value: AttachmentModel) -> Self {
        Self {
            path: value.path.to_str().unwrap_or("").to_owned(),
            file_name: value.file_name,
        }
    }
}

pub struct CreateAttachment {
    pub path: String,
}

#[frb(type_64bit_int)]
pub struct DeleteAttachment {
    pub chat_id: u64,
    pub message_id: u64,
    pub id: u64,
}
