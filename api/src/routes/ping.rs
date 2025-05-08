use crate::interface::handlers::{ping_api_handler, ping_db_handler};
use axum::{Router, routing::get};
use std::sync::Arc;

pub fn ping_routes<R: Send + Sync + 'static>(repo: Arc<R>) -> Router {
    Router::new()
        .route("/ping", get(ping_api_handler))
        .route("/ping/db", get(ping_db_handler))
        .with_state(repo)
}
