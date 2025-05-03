mod language_controller {
    use axum::{Extension, Json};
    use neo4rs::{Graph, query};

    use crate::models;

    #[axum::debug_handler]
    pub async fn ping(Extension(pool): Extension<Graph>) -> axum::response::Response {
        let mut result = pool.execute(query("RETURN 1")).await.unwrap();

        let value = result.next().await.unwrap();

        if value.is_none() {
            return axum::response::Response::builder()
                .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                .body(axum::body::Body::from("Neo4j is not reachable"))
                .unwrap();
        }

        axum::response::Response::builder()
            .status(axum::http::StatusCode::OK)
            .body(axum::body::Body::from("Pong"))
            .unwrap()
    }

    #[axum::debug_handler]
    pub async fn get_words(Extension(pool): Extension<Graph>) -> Json<Vec<models::Word>> {
        let mut result = pool.execute(query("MATCH (n) RETURN n")).await.unwrap();

        let mut words = Vec::new();

        while let Ok(Some(row)) = result.next().await {
            let word: models::Word = row.get("n").unwrap();
            words.push(word);
        }
        Json(words)
    }
}

pub use language_controller::*;
