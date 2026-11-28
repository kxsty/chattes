use std::ffi::OsStr;
use std::fs::{File, OpenOptions, ReadDir};
use std::io::{BufReader, BufWriter, Read, Write};
use std::marker::PhantomData;
use std::path::{Path, PathBuf};
use std::str::FromStr;
use std::{fs, io};

use serde::Serialize;
use serde::de::DeserializeOwned;
use tempfile::NamedTempFile;

use crate::infra::error::Result;

pub struct DirEntryNames<T: FromStr> {
    dir: ReadDir,
    _marker: PhantomData<T>,
}

impl<T: FromStr> DirEntryNames<T> {
    pub fn new<P>(path: P) -> io::Result<Self>
    where
        P: AsRef<Path>,
    {
        Ok(Self {
            dir: path.as_ref().read_dir()?,
            _marker: PhantomData,
        })
    }
}

impl<T: FromStr> Iterator for DirEntryNames<T> {
    type Item = io::Result<T>;
    fn next(&mut self) -> Option<Self::Item> {
        for entry_res in self.dir.by_ref() {
            let entry = match entry_res {
                Ok(entry) => entry,
                Err(err) => return Some(Err(err)),
            };

            let file_name = entry.file_name();
            let Some(str) = file_name.to_str() else {
                continue;
            };

            if let Ok(parsed) = T::from_str(str) {
                return Some(Ok(parsed));
            }
        }
        None
    }
}

pub fn deserialize_from_file<P, T>(path: P) -> Result<Option<T>>
where
    P: AsRef<Path>,
    T: DeserializeOwned,
{
    let path = path.as_ref();

    let value = match OpenOptions::new().read(true).open(path) {
        Ok(f) => yaml_serde::from_reader(BufReader::new(f))?,
        Err(e) if e.kind() == io::ErrorKind::NotFound => None,
        Err(e) => return Err(e.into()),
    };

    Ok(value)
}

pub fn serialize_to_file<P, T>(path: P, value: &T) -> Result<()>
where
    P: AsRef<Path>,
    T: ?Sized + Serialize,
{
    let path = path.as_ref();
    let dir = path.parent().expect("Path must have parent directory");

    let mut tmp_file = NamedTempFile::new_in(dir)?;

    yaml_serde::to_writer(BufWriter::new(&mut tmp_file), value)?;

    tmp_file.flush()?;
    tmp_file.persist(path)?;

    if let Ok(dir) = File::open(dir) {
        let _ = dir.sync_all();
    }

    Ok(())
}

pub fn copy_and_hash_file<P, Q>(from_file_path: P, to_dir_path: Q) -> io::Result<(usize, PathBuf)>
where
    P: AsRef<Path>,
    Q: AsRef<Path>,
{
    let from_file_path = from_file_path.as_ref();
    let to_dir_path = to_dir_path.as_ref();

    let mut from_file = File::open(from_file_path)?;
    let mut temp_to_file = NamedTempFile::new_in(to_dir_path)?;

    let mut reader = BufReader::new(&mut from_file);
    let mut writer = BufWriter::new(&mut temp_to_file);

    let (size, hash) = copy_and_hash_stream(&mut reader, &mut writer)?;

    writer.flush()?;
    drop(writer);
    temp_to_file.as_file().sync_all()?;

    let to_file_path = prepare_hash_based_path(to_dir_path, &hash, from_file_path.extension())?;

    temp_to_file.persist(&to_file_path)?;

    let parent_path = to_file_path
        .parent()
        .expect("Destination file path must have a parent directory");
    if let Ok(parent) = File::open(parent_path) {
        parent.sync_all()?;
    }

    Ok((size, to_file_path))
}

pub fn copy_and_hash_stream<R, W>(
    reader: &mut R,
    writer: &mut W,
) -> io::Result<(usize, blake3::Hash)>
where
    R: Read,
    W: Write,
{
    let mut hasher = blake3::Hasher::new();
    let mut buf = [0u8; 8 * 1024];

    let mut size = 0;

    loop {
        let bytes_read = reader.read(&mut buf)?;
        if bytes_read == 0 {
            break;
        }
        size += bytes_read;

        let chunk = &buf[..bytes_read];
        writer.write_all(chunk)?;
        hasher.update(chunk);
    }

    Ok((size, hasher.finalize()))
}

pub fn prepare_hash_based_path(
    to_dir_path: &Path,
    hash: &blake3::Hash,
    extension: Option<&OsStr>,
) -> io::Result<PathBuf> {
    let mut path = to_dir_path.to_owned();

    let hash_encoded = hash.to_hex();

    path.push(&hash_encoded[..2]);
    fs::create_dir_all(&path)?;

    path.push(hash_encoded.as_str());

    if let Some(extension) = extension {
        path.set_extension(extension.to_ascii_lowercase());
    }

    Ok(path)
}

pub fn remove_parents_while<P, W>(path: P, predicate: W) -> io::Result<bool>
where
    P: AsRef<Path>,
    W: Fn(&Path) -> bool,
{
    let mut removed_any = false;

    let mut path = path.as_ref();
    if !path.exists() {
        return Ok(removed_any);
    }

    while predicate(path) && path.parent().is_some() {
        if path.is_dir() {
            match fs::remove_dir(path) {
                Ok(()) => removed_any = true,
                Err(e) if e.kind() == io::ErrorKind::DirectoryNotEmpty => break,
                Err(e) => return Err(e),
            }
        } else if path.is_file() {
            match fs::remove_file(path) {
                Ok(()) => removed_any = true,
                Err(e) if e.kind() == io::ErrorKind::NotFound => break,
                Err(e) => return Err(e),
            }
        } else {
            break;
        }

        path = path
            .parent()
            .expect("Parent must exist because path.parent().is_some() == true");
    }

    Ok(removed_any)
}

pub fn ensure_parents_exist(path: PathBuf) -> io::Result<PathBuf> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }

    Ok(path)
}

pub fn ensure_exists<P>(path: P) -> io::Result<P>
where
    P: AsRef<Path>,
{
    fs::create_dir_all(path.as_ref())?;

    Ok(path)
}
