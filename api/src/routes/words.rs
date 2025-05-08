use crate::{application::traits::WordRepository, interface::handlers::get_all_words_handler};
use axum::{Router, routing::get};
use std::sync::Arc;

pub fn word_routes<R: WordRepository + Send + Sync + 'static>(repo: Arc<R>) -> Router {
    Router::new()
        .route("/words", get(get_all_words_handler::<R>))
        .with_state(repo)
}
