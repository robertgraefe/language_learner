use async_trait::async_trait;
use anyhow::Result;
use axum::http::StatusCode;

use crate::domain::models::{Translation, Word};

#[async_trait]
pub trait WordRepository {
    async fn get_all(&self) -> Result<Vec<Word>>;
}

pub trait  TranslationRepository {
    async fn upsert(&self, translation: Translation) -> Result<StatusCode>;
}