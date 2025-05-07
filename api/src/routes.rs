use axum::{routing::get, Router};
use std::sync::Arc;
use crate::infrastructure::web::handlers::{get_all_words_handler, ping_api_handler, ping_db_handler};
use crate::application::traits::WordRepository;

pub fn app<R: WordRepository + Send + Sync + 'static>(repo: Arc<R>) -> Router {
    Router::new()
        .route("/api/ping", get(ping_api_handler))
        .route("/api/ping/db", get(ping_db_handler))
        .route("/api/words", get(get_all_words_handler::<R>))
        .route("/api/translation", put(language_controller::upsert_translation::<R>))
        .route(
            "/api/translation/file",
            put(language_controller::upsert_translation_file),
        )
        .with_state(repo)
}