
use axum::http::StatusCode;
use neo4rs::{Graph, query};
use anyhow::Result;
use async_trait::async_trait;

use crate::{application::traits::{TranslationRepository, WordRepository}, domain::models::{translation, Translation, Word}};

pub struct Neo4jWordsRepository {
    pub graph: Graph,
}

pub struct  Neo4jTranslaionRepository{
    pub graph: Graph
}

#[async_trait]
impl WordRepository for Neo4jWordsRepository {
    async fn get_all(&self) -> Result<Vec<Word>> {

            let mut result = self.graph.execute(query("MATCH (n) RETURN n")).await.unwrap();

            let mut words = Vec::new();
    
            while let Ok(Some(row)) = result.next().await {
                let word: Word = row.get("n").unwrap();
                words.push(word);
            }

            Ok(words)
    
    }
}

#[async_trait]
impl TranslationRepository for Neo4jTranslaionRepository {
    async fn upsert(&self, translation: Translation){
        self.graph.run(query(&translation.to_query())).await.unwrap();
    }
}