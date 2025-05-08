mod database;
use std::sync::Arc;

mod application;
mod domain;
mod infrastructure;
mod interface;
mod routes;

use crate::infrastructure::neo4j::neo4j_repo::Neo4jRepository;
use crate::infrastructure::neo4j::neo4j_repo::Neo4jWordsRepository;
use crate::middlewares::error_middleware::error_middleware;

use axum::Router;
use axum::middleware::from_fn;
use dotenvy::dotenv;
use infrastructure::neo4j::neo4j_repo::Neo4jTranslationRepository;
use interface::middlewares;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .compact()
        .init();

    dotenv().ok();

    let graph = Arc::new(database::connect().await);

    let base_repo = Arc::new(Neo4jRepository::new(graph));
    let word_repo = Arc::new(Neo4jWordsRepository::new(base_repo.clone()));
    let translation_repo = Arc::new(Neo4jTranslationRepository::new(base_repo.clone()));

    let app = Router::new()
        .nest("/api", routes::ping::ping_routes(base_repo))
        .nest("/api", routes::words::word_routes(word_repo))
        .nest(
            "/api",
            routes::translation::translation_routes(translation_repo),
        )
        .layer(from_fn(error_middleware));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
