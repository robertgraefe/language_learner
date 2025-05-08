use std::sync::Arc;

use axum::{Json, extract::State, http::StatusCode};

use crate::{application::traits::WordRepository, domain::models::Word};

pub async fn get_all_words_handler<R: WordRepository>(
    State(repo): State<Arc<R>>,
) -> Result<Json<Vec<Word>>, StatusCode> {
    let words = repo
        .get_all()
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(words))
}
