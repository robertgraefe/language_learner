use crate::{
    application::traits::TranslationRepository,
    interface::handlers::{upsert_translation_file_handler, upsert_translation_handler},
};
use axum::{Router, routing::put};
use std::sync::Arc;

pub fn translation_routes<R: TranslationRepository + Send + Sync + 'static>(
    repo: Arc<R>,
) -> Router {
    Router::new()
        .route("/translation", put(upsert_translation_handler::<R>))
        .route(
            "/translation/file",
            put(upsert_translation_file_handler::<R>),
        )
        .with_state(repo)
}
