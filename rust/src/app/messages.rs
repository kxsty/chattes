use crate::app::dto::{
    DeleteMessage, GetMessage, ListMessages, Message, PatchMessage, PostMessage,
};
use crate::app::error::Error::Validation;
use crate::app::error::Result;
use crate::app::ID_GENERATOR;
use crate::domain::model::{Id, Timestamp};
use crate::infra::attachment_store::AttachmentStore;
use crate::infra::chat_store::ChatStore;
use crate::infra::message_store::MessageStore;
use chrono::Utc;
use std::path::Path;
use std::sync::Arc;

#[derive(Clone)]
pub struct Messages {
    chat_store: Arc<ChatStore>,
    msg_store: Arc<MessageStore>,
    att_store: Arc<AttachmentStore>,
}

impl Messages {
    pub(crate) const fn new(
        chat_store: Arc<ChatStore>,
        msg_store: Arc<MessageStore>,
        att_store: Arc<AttachmentStore>,
    ) -> Self {
        Self {
            chat_store,
            msg_store,
            att_store,
        }
    }

    pub fn list(&self, request: ListMessages) -> Result<Vec<Message>> {
        let chat_id = Id::from_raw(request.chat_id);
        let chat_exists = self.chat_store.exists(&chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = request.id_cursor.map(Id::from_raw);

        let messages = self
            .msg_store
            .select(&chat_id, id, request.limit as usize, request.desc)?;
        let response = messages.into_iter().map(Message::from).collect();

        Ok(response)
    }

    pub fn get(&self, request: GetMessage) -> Result<Option<Message>> {
        let chat_id = Id::from_raw(request.chat_id);
        let chat_exists = self.chat_store.exists(&chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = Id::from_raw(request.id);

        let message = self.msg_store.find(&chat_id, &id)?;
        let response = message.map(Message::from);

        Ok(response)
    }

    pub fn post(&self, request: PostMessage) -> Result<Message> {
        let chat_id = Id::from_raw(request.chat_id);
        let chat_exists = self.chat_store.exists(&chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let sent_at = Timestamp::new(Utc::now());

        let mut attachemnts = Vec::with_capacity(request.attachments.len());
        // TODO: parallel execution
        for post_attachment in request.attachments.into_iter() {
            let id = ID_GENERATOR.next_id(|_| panic!());

            let attachment =
                self.att_store
                    .insert(chat_id, id, Path::new(&post_attachment.path))?;
            attachemnts.push(attachment);
        }

        let id = ID_GENERATOR.next_id(|_| panic!());

        let mut message =
            self.msg_store
                .insert(&chat_id, id, sent_at, request.text, attachemnts)?;

        let chat = self
            .chat_store
            .update(&chat_id, None, Some(Some(message)))?
            .expect("Chat should exist");

        message = chat.last_message.expect("Last message should exist");

        let response = Message::from(message);

        Ok(response)
    }

    pub fn patch(&self, request: PatchMessage) -> Result<Message> {
        let chat_id = Id::from_raw(request.chat_id);
        let chat_exists = self.chat_store.exists(&chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = Id::from_raw(request.id);

        let message = self.msg_store.update(&chat_id, &id, request.text)?;
        let response = Message::from(message);

        Ok(response)
    }

    pub fn delete(&self, request: DeleteMessage) -> Result<bool> {
        let chat_id = Id::from_raw(request.chat_id);
        let chat_exists = self.chat_store.exists(&chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = Id::from_raw(request.id);

        let Some(message) = self.msg_store.delete(&chat_id, id)? else {
            return Ok(false);
        };

        for attachment in message.attachments {
            self.att_store.delete(attachment)?;
        }

        Ok(true)
    }
}
