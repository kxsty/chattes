use std::path::Path;
use std::sync::Arc;
use std::thread;

use chrono::Utc;

use crate::app::ID_GENERATOR;
use crate::app::dto::{
    CreateMessage, DeleteMessage, ListMessages, Message, ReadMessage, UpdateMessage,
};
use crate::app::error::Error::Validation;
use crate::app::error::Result;
use crate::domain::attachment::AttachmentModel;
use crate::domain::datetime::DateTimeModel;
use crate::domain::id::IdModel;
use crate::infra::chat_store::ChatStore;
use crate::infra::file_store::FileStore;
use crate::infra::message_store::MessageStore;

#[derive(Clone)]
pub struct Messages {
    chat_store: Arc<ChatStore>,
    msg_store: Arc<MessageStore>,
    file_store: Arc<FileStore>,
}

impl Messages {
    pub(crate) const fn new(
        chat_store: Arc<ChatStore>,
        msg_store: Arc<MessageStore>,
        file_store: Arc<FileStore>,
    ) -> Self {
        Self {
            chat_store,
            msg_store,
            file_store,
        }
    }

    pub fn list(&self, request: ListMessages) -> Result<Vec<Message>> {
        let chat_id = IdModel::from(request.chat_id);
        let chat_exists = self.chat_store.exists(chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = request.id_cursor.map(IdModel::from);

        let messages = self
            .msg_store
            .select(chat_id, id, request.limit as usize, request.desc)?;
        let response = messages.into_iter().map(Message::from).collect();

        Ok(response)
    }

    pub fn read(&self, request: ReadMessage) -> Result<Option<Message>> {
        let chat_id = IdModel::from(request.chat_id);
        let chat_exists = self.chat_store.exists(chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = IdModel::from(request.id);

        let message = self.msg_store.find(chat_id, id)?;
        let response = message.map(Message::from);

        Ok(response)
    }

    pub fn create(&self, request: CreateMessage) -> Result<Message> {
        let chat_id = IdModel::from(request.chat_id);
        let chat_exists = self.chat_store.exists(chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let created_at = DateTimeModel(Utc::now());

        let mut attachments = Vec::with_capacity(request.attachments.len());
        // TODO: parallel execution
        for create_attachment in request.attachments {
            let file_id = IdModel(ID_GENERATOR.next_id(|_| thread::yield_now()));

            let source_path = Path::new(&create_attachment.path);
            let file_name = extract_file_name(source_path);

            let file = self.file_store.insert(file_id, source_path)?;

            let attachment_id = IdModel(ID_GENERATOR.next_id(|_| thread::yield_now()));

            let attachment = AttachmentModel {
                id: attachment_id,
                file,
                name: file_name,
            };

            attachments.push(attachment);
        }

        let id = IdModel(ID_GENERATOR.next_id(|_| thread::yield_now()));

        let mut message =
            self.msg_store
                .insert(chat_id, id, created_at, request.text, attachments)?;

        let chat = self
            .chat_store
            .update(chat_id, None, Some(Some(message)))?
            .expect("Chat should exist");

        message = chat.last_message.expect("Last message should exist");

        let response = Message::from(message);

        Ok(response)
    }

    pub fn update(&self, request: UpdateMessage) -> Result<Message> {
        let chat_id = IdModel::from(request.chat_id);
        let chat_exists = self.chat_store.exists(chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = IdModel::from(request.id);

        let message = self.msg_store.update(chat_id, id, request.text)?;
        let response = Message::from(message);

        Ok(response)
    }

    pub fn delete(&self, request: DeleteMessage) -> Result<bool> {
        let chat_id = IdModel::from(request.chat_id);
        let chat_exists = self.chat_store.exists(chat_id)?;
        if !chat_exists {
            return Err(Validation("Chat not found".into()));
        }

        let id = IdModel::from(request.id);

        let Some(_message) = self.msg_store.delete(chat_id, id)? else {
            return Ok(false);
        };

        // Temporarily disabled attachment clean up
        /*for attachment in message.attachments {
            self.file_store.delete(attachment)?;
        }*/

        Ok(true)
    }
}

fn extract_file_name<P>(path: P) -> String
where
    P: AsRef<Path>,
{
    path.as_ref()
        .file_name()
        .unwrap_or_default()
        .to_string_lossy()
        .into_owned()
}
