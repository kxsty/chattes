use std::fs;
use std::path::Path;
use std::str::FromStr;
use std::sync::Arc;

use sqlx::SqlitePool;
use sqlx::sqlite::SqliteConnectOptions;

use crate::app::chats::Chats;
use crate::app::error::Result;
use crate::app::messages::Messages;
use crate::frb_generated::RustAutoOpaque;
use crate::infra::chat_store::ChatStore;
use crate::infra::file_store::FileStore;
use crate::infra::message_store::MessageStore;

pub struct App {
    pub chats: RustAutoOpaque<Chats>,
    pub messages: RustAutoOpaque<Messages>,
}

impl App {
    pub async fn new(dir: &str) -> Result<Self> {
        let dir = Path::new(dir);

        let mut app_dir = dir.join("chattes");
        fs::create_dir_all(&app_dir)?;

        let db = init_database(&app_dir).await?;

        let chat_store = Arc::new(ChatStore::new(&app_dir)?);

        let attachments_path = Arc::<Path>::from(app_dir.join("attachments"));
        fs::create_dir_all(&attachments_path)?;

        let file_store = Arc::new(FileStore::new(db, attachments_path));

        app_dir.push("chats");
        let chats_path = Arc::<Path>::from(app_dir);

        let msg_store = Arc::new(MessageStore::new(chats_path.clone()));

        let chats = RustAutoOpaque::new(Chats::new(chat_store.clone()));
        let messages = RustAutoOpaque::new(Messages::new(chat_store, msg_store, file_store));

        Ok(Self { chats, messages })
    }
}

async fn init_database<P>(app_dir: P) -> Result<SqlitePool>
where
    P: AsRef<Path>,
{
    let db_url = format!(
        "sqlite:{}",
        app_dir.as_ref().join("data.sqlite").to_string_lossy()
    );
    let db_options = SqliteConnectOptions::from_str(&db_url)?.create_if_missing(true);
    let db = SqlitePool::connect_with(db_options).await?;

    sqlx::migrate!("./migrations").run(&db).await?;

    Ok(db)
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::app::dto::{CreateChat, CreateMessage, ListChats, ListMessages};
    use tempfile::TempDir;

    #[tokio::test]
    async fn chats_list_correct_order() {
        const COUNT: u32 = 100;

        let temp_dir = TempDir::new().unwrap();

        let app = App::new(&temp_dir.path().to_string_lossy()).await.unwrap();
        let chats = app.chats.read().await;
        let messages = app.messages.read().await;

        let mut chat_list = Vec::with_capacity(COUNT as usize);
        for i in 0..COUNT {
            let mut chat = chats
                .create(CreateChat {
                    name: i.to_string(),
                })
                .unwrap();

            chat.last_message = Some(
                messages
                    .create(CreateMessage {
                        chat_id: chat.id,
                        text: String::default(),
                        attachments: Vec::default(),
                    })
                    .await
                    .unwrap(),
            );

            chat_list.push(chat);
        }

        let chat_list_asc = chats
            .list(ListChats {
                last_message_id_cursor: None,
                limit: COUNT,
                desc: false,
            })
            .unwrap();

        assert_eq!(chat_list.len(), chat_list_asc.len());
        for (a, b) in chat_list.iter().zip(chat_list_asc.iter()) {
            assert_eq!(a.id, b.id);
        }

        let chat_list_desc = chats
            .list(ListChats {
                last_message_id_cursor: None,
                limit: COUNT,
                desc: true,
            })
            .unwrap();

        assert_eq!(chat_list.len(), chat_list_desc.len());
        for (a, b) in chat_list.iter().zip(chat_list_desc.iter().rev()) {
            assert_eq!(a.id, b.id);
        }
    }

    #[tokio::test]
    async fn messages_list_correct_order() {
        const COUNT: u32 = 100;

        let temp_dir = TempDir::new().unwrap();

        let app = App::new(&temp_dir.path().to_string_lossy()).await.unwrap();
        let chats = app.chats.read().await;
        let messages = app.messages.read().await;

        let chat = chats
            .create(CreateChat {
                name: "messages_list_correct_order".to_string(),
            })
            .unwrap();

        let mut msg_list = Vec::with_capacity(COUNT as usize);
        for _ in 0..COUNT {
            msg_list.push(
                messages
                    .create(CreateMessage {
                        chat_id: chat.id,
                        text: String::default(),
                        attachments: Vec::default(),
                    })
                    .await
                    .unwrap(),
            );
        }

        let msg_list_asc = messages
            .list(ListMessages {
                chat_id: chat.id,
                id_cursor: None,
                limit: COUNT,
                desc: false,
            })
            .unwrap();

        assert_eq!(msg_list.len(), msg_list_asc.len());
        for (a, b) in msg_list.iter().zip(msg_list_asc.iter()) {
            assert_eq!(a.id, b.id);
        }

        let msg_list_desc = messages
            .list(ListMessages {
                chat_id: chat.id,
                id_cursor: None,
                limit: COUNT,
                desc: true,
            })
            .unwrap();

        assert_eq!(msg_list.len(), msg_list_desc.len());
        for (a, b) in msg_list.iter().zip(msg_list_desc.iter().rev()) {
            assert_eq!(a.id, b.id);
        }
    }
}
