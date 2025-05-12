use std::{collections::HashMap, sync::Arc};

use anyhow::{Context, Result};
use async_trait::async_trait;
use axum::http::StatusCode;
use neo4rs::{Graph, query};
use tracing::error;

use crate::{
    application::traits::{TranslationRepository, WordRepository},
    domain::models::{Translation, Word},
    interface::errors::app_error::AppError,
};

#[derive(Clone)]
pub struct Neo4jRepository {
    pub graph: Arc<Graph>,
}

impl Neo4jRepository {
    pub fn new(graph: Arc<Graph>) -> Self {
        Self { graph }
    }
}

pub struct Neo4jWordsRepository {
    pub base: Arc<Neo4jRepository>,
}

impl Neo4jWordsRepository {
    pub fn new(base: Arc<Neo4jRepository>) -> Self {
        Self { base }
    }
}

pub struct Neo4jTranslationRepository {
    pub base: Arc<Neo4jRepository>,
}

impl Neo4jTranslationRepository {
    pub fn new(base: Arc<Neo4jRepository>) -> Self {
        Self { base }
    }
}

#[async_trait]
impl WordRepository for Neo4jWordsRepository {
    async fn get_all(&self) -> Result<Vec<Word>, AppError> {
        let query_str = "MATCH (n:Word) RETURN n";

        let mut result = match self.base.graph.execute(query(query_str)).await {
            Ok(res) => res,
            Err(e) => {
                error!("Match Words Query failed: '{}': {:?}", query_str, e);
                return Err(AppError::new(
                    StatusCode::BAD_REQUEST,
                    "Failed to execute query",
                ));
            }
        };

        let mut words = Vec::new();

        while let Ok(Some(row)) = result.next().await {
            match row.get("n") {
                Ok(word) => {
                    words.push(word);
                }
                Err(e) => {
                    // Log the error with the query context
                    error!("Failed to get 'n' from row: {:?}, error: {:?}", row, e);

                    // Return the error with additional context
                    return Err(AppError::new(
                        StatusCode::BAD_REQUEST,
                        "Failed to execute query",
                    ));
                }
            }
        }

        Ok(words)
    }
}

#[async_trait]
impl TranslationRepository for Neo4jTranslationRepository {
    async fn upsert(&self, translation: Translation) -> Result<(), AppError> {
        if let Err(e) = self.base.graph.run(query(&translation.to_query())).await {
            error!("Neo4j upsert failed: {:?}", e); // Logs the raw error
            return Err(AppError::new(
                StatusCode::BAD_REQUEST,
                "Failed to execute query",
            ));
        }

        Ok(())
    }

    async fn delete_all(&self) -> Result<(), AppError> {
        let delete_words_query: &str = r#"
            MATCH (w:Word)
            DETACH DELETE w;
        "#;

        self.base
            .graph
            .run(query(delete_words_query))
            .await
            .context("Failed to execute delete words query")?;

        let delete_concepts_query: &str = r#"
            MATCH (c:Concept)
            DETACH DELETE c;
        "#;

        self.base
            .graph
            .run(query(delete_concepts_query))
            .await
            .context("Failed to execute delete concepts query")?;

        Ok(())
    }

    async fn get_all(&self) -> Result<Vec<Translation>, AppError> {
        let query_str = r#"
            MATCH (w:Word)-[:EXPRESSES]->(c:Concept)
            MATCH (w)-[:HAS_LANGUAGE]->(l:Language)
            WITH c, collect([l.code, w.text]) AS lang_word_pairs
            RETURN lang_word_pairs
        "#;

        let mut result = match self.base.graph.execute(query(query_str)).await {
            Ok(res) => res,
            Err(e) => {
                error!("Match Translations Query failed: '{}': {:?}", query_str, e);
                return Err(AppError::new(
                    StatusCode::BAD_REQUEST,
                    "Failed to execute query",
                ));
            }
        };

        let mut translation_groups: Vec<HashMap<String, String>> = Vec::new();

        while let Ok(Some(row)) = result.next().await {
            match row.get::<Vec<Vec<String>>>("lang_word_pairs") {
                Ok(pairs) => {
                    let mut map = HashMap::new();
                    for pair in pairs {
                        if pair.len() == 2 {
                            map.insert(pair[0].clone(), pair[1].clone());
                        } else {
                            error!("Unexpected pair format in row: {:?}", pair);
                            return Err(AppError::new(
                                StatusCode::BAD_REQUEST,
                                "Invalid translation pair",
                            ));
                        }
                    }
                    translation_groups.push(map);
                }
                Err(e) => {
                    error!(
                        "Failed to get 'lang_word_pairs' from row: {:?}, error: {:?}",
                        row, e
                    );
                    return Err(AppError::new(
                        StatusCode::BAD_REQUEST,
                        "Failed to process query result",
                    ));
                }
            }
        }

        let mut translations: Vec<Translation> = Vec::new();

        for map in translation_groups {
            // Extract values safely, or default to empty strings
            let id = map.get("id").cloned().unwrap_or_default();
            let en = map.get("en").cloned().unwrap_or_default();
            let de = map.get("de").cloned().unwrap_or_default();

            translations.push(Translation { id, en, de });
        }

        Ok(translations)
    }
}
