use crate::infra::error::Result;
use serde::de::DeserializeOwned;
use serde::Serialize;
use std::fs::{File, OpenOptions, ReadDir};
use std::io::{BufReader, BufWriter, Write};
use std::marker::PhantomData;
use std::path::{Path, PathBuf};
use std::str::FromStr;
use std::{fs, io};
use tempfile::NamedTempFile;

pub(crate) struct DirEntryNames<T: FromStr> {
    dir: ReadDir,
    _marker: PhantomData<T>,
}
impl<T: FromStr> DirEntryNames<T> {
    pub(crate) fn new<P: AsRef<Path>>(path: P) -> io::Result<Self> {
        Ok(Self {
            dir: path.as_ref().read_dir()?,
            _marker: PhantomData,
        })
    }
}
impl<T: FromStr> Iterator for DirEntryNames<T> {
    type Item = io::Result<T>;
    fn next(&mut self) -> Option<Self::Item> {
        while let Some(entry_res) = self.dir.next() {
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

pub fn deserialize_from_file<P: AsRef<Path>, T: DeserializeOwned>(path: P) -> Result<Option<T>> {
    let path = path.as_ref();

    let value = match OpenOptions::new().read(true).open(path) {
        Ok(f) => yaml_serde::from_reader(BufReader::new(f))?,
        Err(e) if e.kind() == io::ErrorKind::NotFound => None,
        Err(e) => return Err(e.into()),
    };

    Ok(value)
}

pub fn serialize_to_file<P: AsRef<Path>, T: ?Sized + Serialize>(path: P, value: &T) -> Result<()> {
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

/*pub fn update_file_atomic<
    P: AsRef<Path>,
    T: DeserializeOwned + Serialize,
    F: FnOnce(&mut Option<T>) -> R,
    R,
>(
    path: P,
    func: F,
) -> Result<R> {
    static MUTEX: Mutex<()> = Mutex::new(());

    let path = path.as_ref();
    let dir = path.parent().expect("Path must have parent directory");

    let _guard = MUTEX.lock().unwrap();

    let mut prev: Option<T> = match OpenOptions::new().read(true).open(path) {
        Ok(f) => yaml_serde::from_reader(BufReader::new(f))?,
        Err(e) if e.kind() == io::ErrorKind::NotFound => None,
        Err(e) => return Err(e.into()),
    };

    let result = func(&mut prev);
    let Some(next) = prev else {
        return Ok(result);
    };

    let mut tmp_file = NamedTempFile::new_in(dir)?;
    yaml_serde::to_writer(BufWriter::new(&mut tmp_file), &next)?;

    tmp_file.flush()?;
    tmp_file.persist(path)?;

    if let Ok(dir) = File::open(dir) {
        let _ = dir.sync_all();
    }

    Ok(result)

    /*
    static TEMP_DIR: LazyLock<PathBuf> = LazyLock::new(|| env::temp_dir());

    let file_stem = path.canonicalize().unwrap_or(path.to_owned());
    let mut lock_path = PathBuf::with_capacity(
        TEMP_DIR.to_str().unwrap_or("").len()
            + 1
            + file_stem.to_str().unwrap_or("").len()
            + 1
            + LOCK_EXTENSION.len(),
    );
    lock_path.push(TEMP_DIR.as_path());
    lock_path.push(file_stem);
    lock_path.set_extension(LOCK_EXTENSION);

    let lock_file = OpenOptions::new()
        .write(true)
        .read(true)
        .create(true)
        .open(&lock_path)?;

    lock_file.lock()?;*/
}*/

pub fn copy_file<P: AsRef<Path>, Q: AsRef<Path>>(from: P, to: Q) -> io::Result<u64> {
    let to = to.as_ref();
    let dir = to.parent().expect("Path must have parent directory");

    let tmp_file = NamedTempFile::new_in(dir)?;

    let size = fs::copy(from, tmp_file.path())?; // TODO: io::copy() because of File?

    tmp_file.as_file().sync_all()?;
    tmp_file.persist(to)?;

    if let Ok(dir) = File::open(dir) {
        let _ = dir.sync_all();
    }

    Ok(size)
}

pub(crate) fn remove_parents_while<P: AsRef<Path>, W: Fn(&Path) -> bool>(
    path: P,
    predicate: W,
) -> io::Result<bool> {
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
            };
        } else {
            break;
        }

        path = path
            .parent()
            .expect("Parent must exist because path.parent().is_some() == true");
    }

    Ok(removed_any)
}

pub(crate) fn ensure_parents_exist(path: PathBuf) -> io::Result<PathBuf> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }

    Ok(path)
}

pub struct Transaction<F: FnOnce()> {
    queries: Vec<F>,
}
impl<F: FnOnce()> Transaction<F> {
    pub fn execute(&self) {
        // lock

        // for q in queries { q() }

        // unlock
    }
}
