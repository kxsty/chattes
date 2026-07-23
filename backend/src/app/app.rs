use crate::app::chats::Chats;
use crate::app::messages::Messages;
use crate::infra::attachment_store::AttachmentStore;
use crate::infra::chat_store::ChatStore;
use crate::infra::message_store::MessageStore;
use std::fs;
use std::path::Path;
use std::sync::Arc;

pub struct App {
    pub chats: Chats,
    pub messages: Messages,
}

impl App {
    pub fn new() -> Self {
        let data_dir = dirs::data_dir().expect("No data directory");
        Self::new_in_dir(&data_dir)
    }

    fn new_in_dir(dir: &Path) -> Self {
        let app_dir = dir.join("Chattes");
        fs::create_dir_all(&app_dir).expect("Failed to create app data directory");

        let chat_store =
            Arc::new(ChatStore::new(app_dir.clone()).expect("Failed to create chat store"));
        let chats_path = app_dir.join("chats");

        let msg_store = Arc::new(MessageStore::new(chats_path.clone()));
        let att_store = Arc::new(AttachmentStore::new(chats_path));

        let chats = Chats::new(chat_store.clone());
        let messages = Messages::new(chat_store.clone(), msg_store.clone(), att_store.clone());

        Self { chats, messages }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::app::dto::{ListChats, PostChat, PostMessage};
    use tempfile::TempDir;

    #[test]
    fn chats_list_correct_order() {
        const COUNT: usize = 100;

        let temp_dir = TempDir::new().unwrap();

        let app = App::new_in_dir(temp_dir.path());

        let mut chat_list = Vec::with_capacity(COUNT);
        for i in 0..COUNT {
            let mut chat = app
                .chats
                .post(PostChat {
                    name: i.to_string(),
                })
                .unwrap();

            chat.last_message = Some(
                app.messages
                    .post(PostMessage {
                        chat_id: chat.id,
                        text: Default::default(),
                        attachments: Default::default(),
                    })
                    .unwrap(),
            );

            chat_list.push(chat);
        }

        let chat_list_asc = app
            .chats
            .list(ListChats {
                last_message_id_cursor: None,
                limit: COUNT as u32,
                desc: false,
            })
            .unwrap();

        assert_eq!(chat_list.len(), chat_list_asc.len());
        for (a, b) in chat_list.iter().zip(chat_list_asc.iter()) {
            assert_eq!(a.id, b.id);
        }

        let chat_list_desc = app
            .chats
            .list(ListChats {
                last_message_id_cursor: None,
                limit: COUNT as u32,
                desc: true,
            })
            .unwrap();

        assert_eq!(chat_list.len(), chat_list_desc.len());
        for (a, b) in chat_list.iter().zip(chat_list_desc.iter().rev()) {
            assert_eq!(a.id, b.id);
        }
    }
}
