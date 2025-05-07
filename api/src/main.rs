mod database;
mod router;
mod routes;

use std::sync::Arc;

mod infrastructure;
mod domain;
mod application;
mod interface;

use dotenvy::dotenv;
use infrastructure::neo4j::neo4j_repo::Neo4jWordsRepository;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .compact()
        .init();

    dotenv().ok();

    let graph = database::connect().await;

    let repo = Arc::new(Neo4jWordsRepository { graph });

    let app = routes::app(repo);
}
