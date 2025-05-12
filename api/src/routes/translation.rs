use crate::{
    application::traits::TranslationRepository,
    interface::handlers::{delete_translation_all_handler, upsert_translation_file_handler, upsert_translation_handler},
};
use axum::{routing::{delete, put}, Router};
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
        .route("translation/delete/all", delete(delete_translation_all_handler))
        .with_state(repo)
}
