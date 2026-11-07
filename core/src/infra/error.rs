use std::fmt::{Debug, Display, Formatter};
use std::result;
use std::{error, io};
use tempfile::PersistError;

pub type Result<T> = result::Result<T, Error>;

#[derive(Debug)]
pub enum Error {
    IO(io::Error),
    Serialization(String),
    NotFound(String),
}
impl From<io::Error> for Error {
    fn from(value: io::Error) -> Self {
        Self::IO(value)
    }
}
impl From<PersistError> for Error {
    fn from(value: PersistError) -> Self {
        Error::IO(value.error)
    }
}
impl From<yaml_serde::Error> for Error {
    fn from(value: yaml_serde::Error) -> Self {
        Self::Serialization(value.to_string().into())
    }
}
impl error::Error for Error {}
impl Display for Error {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        Debug::fmt(&self, f)
    }
}
