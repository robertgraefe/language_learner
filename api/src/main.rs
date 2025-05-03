mod database;
mod models;
mod router;

// https://awesome-selfhosted.net/
// https://www.youtube.com/watch?v=_gMzg77Qjm0&ab_channel=Let%27sGetRusty

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
