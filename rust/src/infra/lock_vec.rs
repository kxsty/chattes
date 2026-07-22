use dashmap::mapref::entry::Entry;
use dashmap::DashMap;
use std::path::PathBuf;
use std::sync::{Arc, LazyLock, Mutex, Weak};

pub struct MutexMap<K: std::cmp::Eq + std::hash::Hash>(DashMap<K, Weak<Mutex<()>>>);
impl<K: std::cmp::Eq + std::hash::Hash> MutexMap<K> {
    pub fn new() -> Self {
        Self(DashMap::new())
    }

    pub fn get(&self, key: K) -> Arc<Mutex<()>> {
        self.0.retain(|_, v| v.strong_count() > 0);
        match self.0.entry(key) {
            Entry::Occupied(mut entry) => {
                if let Some(arc) = entry.get().upgrade() {
                    return arc;
                }
                let new_lock = Arc::default();
                entry.insert(Arc::downgrade(&new_lock));
                new_lock
            }
            Entry::Vacant(entry) => {
                let new_lock = Arc::default();
                entry.insert(Arc::downgrade(&new_lock));
                new_lock
            }
        }
    }
}

pub(crate) static PATH_LOCKS: LazyLock<MutexMap<PathBuf>> = LazyLock::new(|| MutexMap::new());
