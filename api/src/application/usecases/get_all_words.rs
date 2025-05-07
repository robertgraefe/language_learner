use crate::{application::traits::WordRepository, domain::models::Word};
use anyhow::Result;


pub async fn get_all_words<R: WordRepository>(
    repo: &R
) -> Result<Vec<Word>> {
    repo.get_all().await
}