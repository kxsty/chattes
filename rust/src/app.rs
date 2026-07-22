use ferroid::generator::AtomicSnowflakeGenerator;
use ferroid::id::SnowflakeDiscordId;
use ferroid::time::{DISCORD_EPOCH, MonotonicClock};
use std::sync::LazyLock;

pub mod app;
pub mod attachments;
pub mod chats;
pub mod dto;
mod error;
pub mod messages;

pub static ID_GENERATOR: LazyLock<AtomicSnowflakeGenerator<SnowflakeDiscordId, MonotonicClock>> =
    LazyLock::new(|| {
        AtomicSnowflakeGenerator::new(0, MonotonicClock::<1>::with_epoch(DISCORD_EPOCH))
    });
