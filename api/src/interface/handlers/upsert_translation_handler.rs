use axum::{Json, extract::State, http::StatusCode};
use std::sync::Arc;

use crate::{
    application::traits::TranslationRepository,
    interface::{dtos::translation_dto::UpsertTranslationInput, errors::app_error::AppError},
};

pub async fn upsert_translation_handler<R: TranslationRepository>(
    State(repo): State<Arc<R>>,
    Json(payload): Json<UpsertTranslationInput>,
) -> Result<StatusCode, AppError> {
    let translations = match payload {
        UpsertTranslationInput::Single(dto) => vec![dto],
        UpsertTranslationInput::Multiple(list) => list,
    };

    for dto in translations {
        let domain = dto.to_domain()?; // Use the `?` operator to propagate error if conversion fails

        // If upsert fails, propagate the error as well
        repo.upsert(domain).await?;
    }

    Ok(StatusCode::OK)
}
