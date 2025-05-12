use std::sync::Arc;

use axum::{Json, extract::State};

use crate::{
    application::traits::TranslationRepository, domain::models::Translation,
    interface::errors::app_error::AppError,
};

pub async fn get_translation_all_handler<R: TranslationRepository>(
    State(repo): State<Arc<R>>,
) -> Result<Json<Vec<Translation>>, AppError> {
    let translations = repo.get_all().await?;
    Ok(Json(translations))
}
