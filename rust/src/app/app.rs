use crate::app::chats::Chats;
use crate::app::messages::Messages;
use crate::infra::attachment_store::AttachmentStore;
use crate::infra::chat_store::ChatStore;
use crate::infra::message_store::MessageStore;
use std::fs;
use std::sync::Arc;

pub struct App {
    pub chats: Chats,
    pub messages: Messages,
    // pub attachments: Attachments,
}

impl App {
    pub fn new() -> Self {
        let data_dir = dirs::data_dir().expect("No data directory");
        let app_dir = data_dir.join("Chattes");
        fs::create_dir_all(&app_dir).expect("Failed to create app data directory");

        let chat_store =
            Arc::new(ChatStore::new(app_dir.clone()).expect("Failed to create chat store"));
        let chats_path = app_dir.join("chats");

        let msg_store = Arc::new(MessageStore::new(chats_path.clone()));
        let att_store = Arc::new(AttachmentStore::new(chats_path));

        let chats = Chats::new(chat_store.clone());
        let messages = Messages::new(chat_store.clone(), msg_store.clone(), att_store.clone());
        // let attachments = Attachments::new(chat_store, msg_store, att_store);

        Self {
            chats,
            messages,
            // attachments,
        }
    }
}
