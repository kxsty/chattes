use std::{
    ops::{Deref, DerefMut},
    str::FromStr,
};

use ferroid::{base32, id::SnowflakeDiscordId, serde::snow_as_base32};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct IdModel(#[serde(with = "snow_as_base32")] pub SnowflakeDiscordId);

impl From<u64> for IdModel {
    fn from(value: u64) -> Self {
        Self(SnowflakeDiscordId::from_raw(value))
    }
}

impl From<IdModel> for u64 {
    fn from(value: IdModel) -> Self {
        value.to_raw()
    }
}

impl FromStr for IdModel {
    type Err = base32::Error<SnowflakeDiscordId>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        SnowflakeDiscordId::from_str(s).map(Self)
    }
}

impl Deref for IdModel {
    type Target = SnowflakeDiscordId;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for IdModel {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}
