use std::net::SocketAddr;
use std::sync::Arc;

mod application;
mod database;
mod domain;
mod infrastructure;
mod interface;
mod routes;

use crate::infrastructure::neo4j::neo4j_repo::Neo4jRepository;
use crate::infrastructure::neo4j::neo4j_repo::Neo4jWordsRepository;
use crate::middlewares::error_middleware::error_middleware;

use axum::Router;
use axum::middleware::from_fn;
use database::migrations::run_migrations;
use dotenvy::dotenv;
use infrastructure::neo4j::neo4j_repo::Neo4jTranslationRepository;
use interface::middlewares;
use tracing::info;
use axum_server::tls_rustls::RustlsConfig;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .compact()
        .init();

    dotenv().ok();

    //rustls::crypto::ring::default_provider().install_default().expect("Failed to install rustls crypto provider");

    let graph = Arc::new(database::connect().await);

    if let Err(e) = run_migrations(&graph).await {
        eprintln!("Migration error: {:?}", e);
    }

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

    info!("Server started...");

    axum::serve(listener, app).await.unwrap();

    /*
    let config = RustlsConfig::from_pem_file(
        "assets/cert.pem",
        "assets/key.pem",
    )
    .await
    .unwrap();

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));

    println!("https listening on {}", addr);

    let _ = axum_server_dual_protocol::bind_dual_protocol(addr, config)
	.serve(app.into_make_service())
	.await;
 */

}