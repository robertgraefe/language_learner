use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Translation {
    pub id: String,
    pub en: String,
    pub de: String,
}

impl Translation {
    pub fn to_query(&self) -> String {
        let mut query = String::new();

        query.push_str(&format!(
            "MERGE (id:Word {{text: '{}', language: 'id'}})\n",
            self.id
        ));
        query.push_str(&format!(
            "MERGE (en:Word {{text: '{}', language: 'en'}})\n",
            self.en
        ));
        query.push_str(&format!(
            "MERGE (de:Word {{text: '{}', language: 'de'}})\n",
            self.de
        ));

        query.push_str("MERGE (id)-[:TRANSLATES_TO]->(en)\n");
        query.push_str("MERGE (id)-[:TRANSLATES_TO]->(de)\n");

        query.push_str("MERGE (en)-[:TRANSLATES_TO]->(id)\n");
        query.push_str("MERGE (en)-[:TRANSLATES_TO]->(de)\n");

        query.push_str("MERGE (de)-[:TRANSLATES_TO]->(id)\n");
        query.push_str("MERGE (de)-[:TRANSLATES_TO]->(en)\n");

        return query;
    }
}