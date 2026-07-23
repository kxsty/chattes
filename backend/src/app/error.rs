use crate::domain::error::ValidationError;
use crate::infra;
use std::fmt::{Debug, Display, Formatter};
use std::{error, io, result};

pub type Result<T> = result::Result<T, Error>;

#[derive(Debug)]
pub enum Error {
    Infrastructure(String),
    Validation(ValidationError),
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
impl From<ValidationError> for Error {
    fn from(value: ValidationError) -> Self {
        Self::Validation(value)
    }
}
impl error::Error for Error {}
impl Display for Error {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        Debug::fmt(&self, f)
    }
}
