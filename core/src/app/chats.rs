use crate::app::dto::{Chat, DeleteChat, GetChat, ListChats, PatchChat, PostChat};
use crate::app::error::Error::Validation;
use crate::app::error::Result;
use crate::app::ID_GENERATOR;
use crate::domain::model::Id;
use crate::infra::chat_store::ChatStore;
use std::sync::Arc;
use std::thread;

#[derive(Clone)]
pub struct Chats {
    chat_store: Arc<ChatStore>,
}

impl Chats {
    pub(crate) fn new(chat_store: Arc<ChatStore>) -> Self {
        Self { chat_store }
    }

    pub fn list(&self, request: ListChats) -> Result<Vec<Chat>> {
        let last_message_id_cursor = request.last_message_id_cursor.map(Id::from_raw);

        let chats =
            self.chat_store
                .select(last_message_id_cursor, request.desc, request.limit as usize)?;
        let response = chats.into_iter().map(Chat::from).collect();

        Ok(response)
    }

    pub fn get(&self, request: GetChat) -> Result<Option<Chat>> {
        let id = Id::from_raw(request.id);

        let chat = self.chat_store.find(&id)?;
        let response = chat.map(Chat::from);

        Ok(response)
    }

    pub fn post(&self, request: PostChat) -> Result<Chat> {
        let id = ID_GENERATOR.next_id(|_| {
            thread::yield_now();
        });

        if request.name.len() > u8::MAX as usize {
            return Err(Validation("Chat name too long".into()));
        }

        let chat = self.chat_store.insert(id, request.name, None)?;
        let response = Chat::from(chat);

        Ok(response)
    }

    pub fn patch(&self, request: PatchChat) -> Result<Option<Chat>> {
        let id = Id::from_raw(request.id);

        let chat = self.chat_store.update(&id, request.name, None)?;
        let response = chat.map(Chat::from);

        Ok(response)
    }

    pub fn delete(&self, request: DeleteChat) -> Result<bool> {
        let id = Id::from_raw(request.id);

        let response = self.chat_store.delete(&id)?;

        Ok(response)
    }
}
