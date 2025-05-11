use std::sync::Arc;

use axum::{extract::State, http::StatusCode};

use crate::{
    application::traits::TranslationRepository, interface::errors::app_error::AppError,
};

pub async fn delete_translation_all_handler<R: TranslationRepository>(
    State(repo): State<Arc<R>>,
) -> Result<StatusCode, AppError> {
    repo.delete_all().await?;
    Ok(StatusCode::OK)
}
