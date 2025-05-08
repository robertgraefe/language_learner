use anyhow::Result;
use async_trait::async_trait;

use crate::domain::models::{Translation, Word};

#[async_trait]
pub trait WordRepository {
    async fn get_all(&self) -> Result<Vec<Word>>;
}

#[async_trait]
pub trait TranslationRepository {
    async fn upsert(&self, translation: Translation);
}
