mod database;
mod models;
mod router;

use dotenvy::dotenv;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .compact()
        .init();

    dotenv().ok();

    let graph = database::connect().await;

    router::start(graph).await;
}
