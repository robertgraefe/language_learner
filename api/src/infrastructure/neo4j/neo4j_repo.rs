use std::sync::Arc;

use anyhow::{Context, Result};
use async_trait::async_trait;
use neo4rs::{Graph, query};

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
    async fn get_all(&self) -> Result<Vec<Word>> {
        let mut result = self
            .base
            .graph
            .execute(query("MATCH (n) RETURN n"))
            .await
            .context("Failed to execute query")?;

        let mut words = Vec::new();

        while let Ok(Some(row)) = result.next().await {
            let word: Word = row.get("n").context("Could not get words")?;
            words.push(word);
        }

        Ok(words)
    }
}

#[async_trait]
impl TranslationRepository for Neo4jTranslationRepository {
    async fn upsert(&self, translation: Translation) -> Result<(), AppError> {
        self.base
            .graph
            .run(query(&translation.to_query()))
            .await
            .context("Failed to execute query")?;
        Ok(())
    }

    async fn delete_all(&self) -> Result<(), AppError> {

        let query_str: &str = r#"
            MATCH (w:Word)
            DETACH DELETE w;
            
            MATCH (c:Concept)
            DETACH DELETE c;
        "#;


        self.base
            .graph
            .run(query(query_str))
            .await
            .context("Failed to execute query")?;
        Ok(())
    }
}
