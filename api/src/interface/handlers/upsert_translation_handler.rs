use std::sync::Arc;


use axum::{extract::State, http::StatusCode, Json};

use crate::{application::traits::TranslationRepository, interface::dtos::translation_dto::UpsertTranslationInput};

pub async fn upsert_translation_handler<R: TranslationRepository>(
    State(repo): State<Arc<R>>,
    Json(payload): Json<UpsertTranslationInput>,
) -> Result<StatusCode, StatusCode> {

    let translations = match payload {
        UpsertTranslationInput::Single(dto) => vec![dto],
        UpsertTranslationInput::Multiple(list) => list,
    };

    for dto in translations {
        match dto.to_domain() {
            Ok(t) => {
                repo.upsert(t).await; 
            }
            Err(_) => return Err(StatusCode::UNPROCESSABLE_ENTITY), // Return 422 if domain conversion fails
        }
    }

    Ok(StatusCode::OK)
}