use rust_lib_chattes::app::app::App;
use rust_lib_chattes::app::dto::{
    ListMessages, PatchMessage, PostAttachment, PostChat, PostMessage,
};
use std::time::Instant;

#[tokio::main]
async fn main() {
    let app = App::new();

    let chat = app
        .chats
        .post(PostChat {
            name: "My chat".to_owned(),
        })
        .unwrap();

    for _ in 0..1000 {
        let instant = Instant::now();

        let message = app
            .messages
            .post(PostMessage {
                chat_id: chat.id.clone(),
                text: "Hello from mars".to_owned(),
                attachments: vec![PostAttachment {
                    path: r"C:\Users\kxsty\Desktop\01 - IGOR'S THEME.png".to_owned(),
                }],
            })
            .unwrap();

        app.messages
            .patch(PatchMessage {
                chat_id: chat.id.clone(),
                id: message.id.clone(),
                text: Some("New text".to_owned()),
            })
            .unwrap();

        let messages = app
            .messages
            .list(ListMessages {
                chat_id: chat.id.clone(),
                id: None,
                limit: 1000,
                desc: true,
            })
            .unwrap();
        let _ = messages;

        let duration = instant.elapsed();
        println!("{:?}", duration);
    }

    /*
    let mut handles = Vec::new();

    for _ in 0..1000 {
        let app = Arc::clone(&app);
        let handle = tokio::spawn(async move {
            // Move ALL blocking I/O off the async worker thread
            tokio::task::spawn_blocking(move || {
                let chat = app
                    .chats
                    .post(PostChat {
                        name: "My chat".to_owned(),
                    })
                    .unwrap();
                app.messages
                    .post(PostMessage {
                        chat_id: chat.id,
                        text: "Hello from mars".to_owned(),
                        attachments: vec![PostAttachment {
                            path: r"C:\Users\kxsty\Desktop\01 - IGOR'S THEME.png".to_owned(),
                        }],
                    })
                    .unwrap();
            })
            .await
            .unwrap()
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.await.unwrap();
    }*/

    /*    let list = app
        .messages
        .list(ListMessages {
            chat_id: chat.id.clone(),
            id: None,
            limit: 25,
            reverse: false,
        })
        .unwrap();

    for i in 0..25 {
        assert_eq!(messages[i].id, list[i].id);
    }

    let list = app
        .messages
        .list(ListMessages {
            chat_id: chat.id.clone(),
            id: None,
            limit: 25,
            reverse: true,
        })
        .unwrap();

    for (a, b) in list.iter().zip(messages.iter().rev()) {
        assert_eq!(a.id, b.id);
    }*/
}
