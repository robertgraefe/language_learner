use async_trait::async_trait;
use anyhow::Result;

use crate::domain::models::Word;

#[async_trait]
pub trait WordRepository {
    async fn get_all(&self) -> Result<Vec<Word>>;
}

