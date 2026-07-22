/* use std::sync::Arc;
use crate::app::app::App;
use crate::app::dto::{ChatModel, ListMessages};
use crate::app::messages::Messages;

pub struct MessageState {
    app: Arc<App>,
    chat_id: u64,
    messages: Vec<Messages>
}
impl MessageState {
    pub fn new(app: Arc<App>) -> Self {
        let messages = app.messages.list(ListMessages {
            chat_id: 0,
            id: None,
            limit: 0,
            desc: false,
        }).unwrap();
    }

    pub fn messages() {

    }
}

pub struct ChatState {
    chat: ChatModel,
}

pub struct AppState {
    selected_chat: Option<ChatModel>,
    chats: Vec<ChatState>,
}

impl AppState {
    pub fn messages() {

    }

    pub fn select
} */
