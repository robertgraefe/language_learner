use std::sync::Arc;

use axum::{Json, extract::State};

use crate::{
    application::traits::WordRepository, domain::models::Word,
    interface::errors::app_error::AppError,
};

pub async fn get_all_words_handler<R: WordRepository>(
    State(repo): State<Arc<R>>,
) -> Result<Json<Vec<Word>>, AppError> {
    let words = repo.get_all().await?;
    Ok(Json(words))
}
