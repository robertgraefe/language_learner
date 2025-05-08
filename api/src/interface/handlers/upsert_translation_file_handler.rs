use std::sync::Arc;

use axum::{
    Json,
    extract::{Multipart, State},
    http::StatusCode,
};

use crate::{
    application::traits::TranslationRepository,
    interface::{dtos::translation_dto::UpsertTranslationInput, errors::app_error::AppError},
};

use super::upsert_translation_handler;

pub async fn upsert_translation_file_handler<R: TranslationRepository>(
    State(repo): State<Arc<R>>,
    mut multipart: Multipart,
) -> Result<StatusCode, AppError> {
    let mut dto_opt: Option<UpsertTranslationInput> = None;

    while let Some(field) = multipart.next_field().await.unwrap() {
        if let Some(name) = field.name() {
            if name == "file" {
                let bytes = field.bytes().await.unwrap();

                // Try to deserialize directly into your DTO
                dto_opt = Some(serde_json::from_slice::<UpsertTranslationInput>(&bytes)?);
            }
        }
    }

    if let Some(dto) = dto_opt {
        // Call your handler with DTO instead of Value
        return upsert_translation_handler(State(repo), Json(dto)).await;
    }

    Err(AppError::new_status(StatusCode::BAD_REQUEST))
}
