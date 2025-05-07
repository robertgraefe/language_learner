use std::sync::Arc;

use axum::{extract::State, http::StatusCode, Json};

use crate::{application::traits::{TranslationRepository, WordRepository}, domain::models::{Translation, Word}};







pub async fn ping_api_handler() -> StatusCode {
    StatusCode::OK
}

pub async fn ping_db_handler() -> StatusCode {
    StatusCode::OK
}


pub async fn get_all_words_handler<R: WordRepository>(
    State(repo): State<Arc<R>>, 
) -> Result<Json<Vec<Word>>, StatusCode> {
    let words = repo.get_all().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(words))
}

pub async fn upsert_translation_handler<R: TranslationRepository>(State(repo): State<Arc<R>>, Json(translation): Json<Translation>,) -> StatusCode {

    return repo.upsert(translation).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR);


    
}