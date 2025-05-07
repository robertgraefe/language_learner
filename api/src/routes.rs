use axum::{routing::get, Router};
use std::sync::Arc;
use crate::infrastructure::web::handlers::get_all_words_handler;
use crate::application::traits::WordRepository;

pub fn app<R: WordRepository + Send + Sync + 'static>(repo: Arc<R>) -> Router {
    Router::new()
        .route("/words", get(get_all_words_handler::<R>))
        .with_state(repo)
}
