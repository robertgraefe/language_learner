mod language_controller;

mod router {

    use crate::router::language_controller;
    use axum::{Extension, Router, routing::get};
    use neo4rs::Graph;
    use tower_http::trace::TraceLayer;
    use tracing::Level;

    pub async fn start(graph: Graph) {
        let app = Router::new()
            .route("/", get(language_controller::ping))
            .route("/words", get(language_controller::get_words))
            .layer(Extension(graph))
            .layer(
                TraceLayer::new_for_http()
                    .make_span_with(tower_http::trace::DefaultMakeSpan::new().level(Level::INFO))
                    .on_response(tower_http::trace::DefaultOnResponse::new().level(Level::INFO)),
            );

        let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();

        tracing::info!("listening on {}", listener.local_addr().unwrap());

        axum::serve(listener, app).await.unwrap();
    }
}

pub use router::*;
