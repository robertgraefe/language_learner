use anyhow::Result;
use async_trait::async_trait;

use crate::{
    domain::models::{Translation, Word},
    interface::errors::app_error::AppError,
};

#[async_trait]
pub trait WordRepository {
    async fn get_all(&self) -> Result<Vec<Word>>;
}


#[async_trait]
pub trait TranslationRepository {
    async fn upsert(&self, translation: Translation) -> Result<(), AppError>;
    async fn delete_all(&self) -> Result<(), AppError>;
}
