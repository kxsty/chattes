use std::{
    ops::{Deref, DerefMut},
    str::FromStr,
};

use ferroid::{base32, id::SnowflakeDiscordId, serde::snow_as_base32};
use serde::{Deserialize, Serialize};
use sqlx::{Sqlite, encode::IsNull, error::BoxDynError, sqlite::SqliteArgumentsBuffer};

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

impl From<i64> for IdModel {
    fn from(value: i64) -> Self {
        Self::from(value.cast_unsigned())
    }
}

impl From<IdModel> for i64 {
    fn from(value: IdModel) -> Self {
        u64::from(value).cast_signed()
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

impl sqlx::Type<Sqlite> for IdModel {
    fn type_info() -> <Sqlite as sqlx::Database>::TypeInfo {
        <i64 as sqlx::Type<Sqlite>>::type_info()
    }
}

impl sqlx::Encode<'_, Sqlite> for IdModel {
    fn encode_by_ref(&self, buf: &mut SqliteArgumentsBuffer) -> Result<IsNull, BoxDynError> {
        <i64 as sqlx::Encode<Sqlite>>::encode_by_ref(&i64::from(*self), buf)
    }
}
