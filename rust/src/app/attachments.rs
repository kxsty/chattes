/*use crate::app::dto::DeleteAttachment;
use crate::app::error::Error::Validation;
use crate::app::error::Result;
use crate::domain::enitity::Id;
use crate::infra::attachment_store::AttachmentStore;
use crate::infra::chat_store::ChatStore;
use crate::infra::message_store::MessageStore;
use std::sync::Arc;

pub struct Attachments {
    chat_store: Arc<ChatStore>,
    msg_store: Arc<MessageStore>,
    att_store: Arc<AttachmentStore>,
}
impl Attachments {
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

    // TODO: Add locks in app logic

    pub fn delete(&self, request: DeleteAttachment) -> Result<bool> {
        let chat_id = Id::from_raw(request.chat_id);
        let Some(chat) = self.chat_store.find(&chat_id)? else {
            return Err(Validation("Chat not found".into()));
        };

        let message_id = Id::from_raw(request.message_id);
        let message_exists = self.msg_store.exists(&chat_id, &message_id)?;
        if !message_exists {
            return Err(Validation("Message not found".into()));
        }

        let id = Id::from_raw(request.id);

        let Some(attachment) = self
            .msg_store
            .attachments_remove(&chat_id, &message_id, id)?
        else {
            return Ok(false);
        };

        self.att_store.delete(attachment)?;

        let Some(mut last_message) = chat.last_message else {
            return Ok(true);
        };

        if last_message.id == message_id {
            let Some(index) = last_message.attachments.iter().position(|a| a.id == id) else {
                return Ok(true);
            };

            last_message.attachments.remove(index);

            self.chat_store
                .update(&chat_id, None, Some(Some(last_message)))?;
        }

        Ok(true)
    }
}*/
