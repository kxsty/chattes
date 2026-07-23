use crate::domain::error::ValidationError;
use chrono::{DateTime, Datelike, Utc};
use ferroid::id::SnowflakeDiscordId;
use ferroid::serde::snow_as_base32;
use ferroid::time::DISCORD_EPOCH;
use serde::{Deserialize, Serialize};
use std::borrow::Borrow;
use std::cmp::Ordering;
use std::fmt;
use std::fmt::{Display, Formatter};
use std::path::PathBuf;
use std::str::FromStr;
use std::time::SystemTime;

pub type Id = SnowflakeDiscordId;

#[derive(Serialize, Deserialize)]
pub struct ChatModel {
    #[serde(with = "snow_as_base32")]
    pub id: Id,
    pub name: String,
    pub last_message: Option<MessageModel>,
}
impl Ord for ChatModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.last_message.cmp(&other.last_message)
    }
}
impl PartialOrd for ChatModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.last_message.partial_cmp(&other.last_message)
    }
}
impl Eq for ChatModel {}
impl PartialEq for ChatModel {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

#[derive(Serialize, Deserialize)]
/// Owned by Chat
pub struct MessageModel {
    #[serde(with = "snow_as_base32")]
    pub id: Id,
    pub text: String,
    pub attachments: Vec<AttachmentModel>,
    pub sent_at: Timestamp,
    pub updated_at: Timestamp,
}
impl Ord for MessageModel {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}
impl PartialOrd for MessageModel {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.id.partial_cmp(&other.id)
    }
}
impl Eq for MessageModel {}
impl PartialEq for MessageModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}
impl Borrow<Id> for MessageModel {
    fn borrow(&self) -> &Id {
        &self.id
    }
}

#[derive(Serialize, Deserialize)]
/// Owned by Message
pub struct AttachmentModel {
    #[serde(with = "snow_as_base32")]
    pub id: Id,
    pub path: PathBuf,
    pub file_name: String,
    pub size: u64,
}
impl Eq for AttachmentModel {}
impl PartialEq for AttachmentModel {
    fn eq(&self, other: &Self) -> bool {
        self.id.eq(&other.id)
    }
}

#[derive(Clone, Default, Serialize, Deserialize)]
pub struct Timestamp(DateTime<Utc>);
impl Timestamp {
    pub const fn new(date_time: DateTime<Utc>) -> Self {
        Self(date_time)
    }
    pub fn year(&self) -> Year {
        Year::new(self.0.year() as i16)
    }
    pub fn month(&self) -> Month {
        Month::new(self.0.month() as i8).expect("Datetime supposed to have a valid month")
    }
    pub fn day(&self) -> Day {
        Day::new(self.0.day() as i8).expect("Datetime supposed to have a valid day")
    }
}
impl From<Timestamp> for DateTime<Utc> {
    fn from(value: Timestamp) -> Self {
        value.0
    }
}
impl From<SystemTime> for Timestamp {
    fn from(value: SystemTime) -> Self {
        Self(DateTime::<Utc>::from(value))
    }
}
impl From<Timestamp> for SystemTime {
    fn from(value: Timestamp) -> Self {
        value.0.into()
    }
}
impl From<&Id> for Timestamp {
    fn from(value: &Id) -> Self {
        let timestamp = value.timestamp() + DISCORD_EPOCH.as_millis() as u64;
        Self::new(DateTime::<Utc>::from_timestamp_millis(timestamp as i64).unwrap())
    }
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Year(i16);
impl Year {
    const fn new(year: i16) -> Self {
        Self(year)
    }
    const fn is_leap(&self) -> bool {
        (self.0 % 4 == 0 && self.0 % 100 != 0) || self.0 % 400 == 0
    }
}
impl FromStr for Year {
    type Err = ValidationError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let year = s.parse::<i16>()?;
        Ok(Year::new(year))
    }
}
impl Display for Year {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "{:04}", self.0)
    }
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Month(i8);
impl Month {
    const fn new(month: i8) -> Option<Self> {
        if month < 1 || month > 12 {
            return None;
        }

        Some(Self(month))
    }

    pub const MIN: Self = Month(1);
    pub const MAX: Self = Month(12);
}
impl FromStr for Month {
    type Err = ValidationError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let month = s.parse::<i8>()?;
        Month::new(month).ok_or_else(|| "Invalid month value".into())
    }
}
impl Display for Month {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "{:02}", self.0)
    }
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Day(i8);
impl Day {
    const fn new(day: i8) -> Option<Self> {
        if day < 1 || day > 31 {
            return None;
        }

        Some(Self(day))
    }
    pub const fn max(year: Year, month: Month) -> Day {
        Self(match month.0 {
            1 // January
            | 3 // March
            | 5 // May
            | 7 // July
            | 8 // August
            | 10 // October
            | 12 // December
            => 31,

            4 // April
            | 6 // June
            | 9 // September
            | 11 // November
            => 30,

            2 // February
            => if !year.is_leap() {
                28
            } else {
                29
            },

            _ => unreachable!(),
        })
    }

    pub const MIN: Self = Day(1);
}
impl FromStr for Day {
    type Err = ValidationError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let day = s.parse::<i8>()?;
        Day::new(day).ok_or_else(|| "Invalid day value".into())
    }
}
impl Display for Day {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "{:02}", self.0)
    }
}
