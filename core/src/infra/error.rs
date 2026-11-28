use std::fmt::Debug;
use std::io;
use std::result;

use tempfile::PersistError;
use thiserror::Error;

pub type Result<T> = result::Result<T, Error>;

#[derive(Debug, Error)]
pub enum Error {
    #[error("{0}")]
    IO(#[from] io::Error),
    #[error("{0}")]
    Serialization(String),
    #[error("{0}")]
    NotFound(String),
}

impl From<PersistError> for Error {
    fn from(value: PersistError) -> Self {
        Error::IO(value.error)
    }
}

impl From<yaml_serde::Error> for Error {
    fn from(value: yaml_serde::Error) -> Self {
        Self::Serialization(value.to_string())
    }
}
