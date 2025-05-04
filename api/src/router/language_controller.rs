mod language_controller {
    use axum::{Extension, Json};
    use neo4rs::{Graph, query};

    use crate::models;

    #[axum::debug_handler]
    pub async fn ping() -> Json<bool> {
        Json(true)
    }

    #[axum::debug_handler]
    pub async fn ping_db(Extension(pool): Extension<Graph>) -> Json<bool> {
        let mut result = pool.execute(query("RETURN 1")).await.unwrap();

        if result.next().await.unwrap().is_none() {
            panic!("Neo4j is not reachable");
        }

        Json(true)
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
