use std::fmt::Debug;
use std::{io, result};

use flutter_rust_bridge::frb;
use sqlx::migrate::MigrateError;
use thiserror::Error;

use crate::infra;

pub type Result<T> = result::Result<T, Error>;

#[derive(Debug, Error)]
#[frb(opaque)]
pub enum Error {
    #[error("{0}")]
    Infrastructure(String),
    #[error("{0}")]
    Validation(String),
}

impl From<infra::error::Error> for Error {
    fn from(value: infra::error::Error) -> Self {
        Self::Infrastructure(value.to_string())
    }
}

impl From<io::Error> for Error {
    fn from(value: io::Error) -> Self {
        Self::Infrastructure(value.to_string())
    }
}

impl From<sqlx::Error> for Error {
    fn from(value: sqlx::Error) -> Self {
        Self::Infrastructure(value.to_string())
    }
}

impl From<MigrateError> for Error {
    fn from(value: MigrateError) -> Self {
        Self::Infrastructure(value.to_string())
    }
}
