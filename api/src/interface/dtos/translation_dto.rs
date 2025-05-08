use serde::Deserialize;

use crate::{domain::models::Translation, interface::errors::app_error::AppError};

#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum UpsertTranslationInput {
    Single(TranslationDto),
    Multiple(Vec<TranslationDto>),
}

#[derive(Debug, Deserialize)]
pub struct TranslationDto {
    pub id: String,
    pub en: String,
    pub de: String,
}

impl TranslationDto {
    pub fn to_domain(self) -> Result<Translation, AppError> {
        if self.id.trim().is_empty() || self.en.trim().is_empty() || self.de.trim().is_empty() {
            return Err(AppError::new(
                axum::http::StatusCode::UNPROCESSABLE_ENTITY,
                "All fields must be non-empty",
            ));
        }

        Ok(Translation {
            id: self.id.trim().to_owned(),
            en: self.en.trim().to_owned(),
            de: self.de.trim().to_owned(),
        })
    }
}
