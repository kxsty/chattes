use std::error::Error;
use std::fmt::{Debug, Display, Formatter};
use std::num::ParseIntError;

#[derive(Debug)]
pub struct ValidationError(String);
impl From<String> for ValidationError {
    fn from(value: String) -> Self {
        Self(value)
    }
}
impl From<&str> for ValidationError {
    fn from(value: &str) -> Self {
        Self(value.to_owned())
    }
}
impl From<ParseIntError> for ValidationError {
    fn from(value: ParseIntError) -> Self {
        Self(value.to_string())
    }
}
impl Error for ValidationError {}
impl Display for ValidationError {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "{}", self.0)
    }
}
