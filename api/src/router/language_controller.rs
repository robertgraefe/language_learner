mod language_controller {
    use axum::extract::Multipart;
    use axum::{Extension, Json};
    use neo4rs::{Graph, query};
    use serde_json::Value;



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

    /*
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
    */

    /*
    #[axum::debug_handler]
    pub async fn upsert_translation(
        Extension(pool): Extension<Graph>,
        Json(json): Json<Value>,
    ) -> Json<bool> {
        let value = serde_json::to_value(json).unwrap();

        let translations = get_translation(value);

        for translation in translations {
            let _ = pool.run(query(&translation.to_query())).await.unwrap();
        }

        Json(true)
    }
    */

    /*
    #[axum::debug_handler]
    pub async fn upsert_translation_file(
        Extension(pool): Extension<Graph>,
        mut multipart: Multipart,
    ) -> Json<bool> {
        let mut file_data = Value::Null;

        // Process each part of the multipart form
        while let Some(field) = multipart.next_field().await.unwrap() {
            if let Some(name) = field.name() {
                if name == "file" {
                    // Read the file content into memory
                    let mut file_content = Vec::new();
                    file_content.extend_from_slice(&field.bytes().await.unwrap());

                    // Parse the file content as JSON
                    file_data = serde_json::from_slice(&file_content).unwrap_or(Value::Null);
                    break; // Assuming there's only one file, break after the first one is processed
                }
            }
        }

        return upsert_translation(Extension(pool), Json(file_data)).await;
    }
 */

    /*
    fn get_translation(value: Value) -> Vec<models::Translation> {
        let translations = if let Value::Array(array) = value {
            array
                .into_iter()
                .filter_map(|item| {
                    if let Value::Object(map) = item {
                        let translation = serde_json::from_value(Value::Object(map)).unwrap();
                        Some(translation)
                    } else {
                        None
                    }
                })
                .collect::<Vec<models::Translation>>()
        } else {
            panic!("Expected a list of translations, but got a different format");
        };
        return translations;
    }
     */
}

pub use language_controller::*;
