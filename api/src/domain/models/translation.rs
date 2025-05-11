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

        query.push_str("MATCH (en_l:Language {{code: 'en', name: 'English'}})\n");
        query.push_str("MATCH (id_l:Language {{code: 'id', name: 'Indonesian'}})\n");
        query.push_str("MATCH (de_l:Language {{code: 'de', name: 'German'}})\n");

        query.push_str(&format!(
            "MERGE (id_w:Word {{text: '{}'}})\n",
            self.id
        ));

        query.push_str(&format!(
            "MERGE (en_w:Word {{text: '{}'}})\n",
            self.en
        ));

        query.push_str(&format!(
            "MERGE (de_w:Word {{text: '{}'}})\n",
            self.de
        ));

        query.push_str("MERGE (c:Concept)\n");

        query.push_str("MERGE (en_w)-[:HAS_LANGUAGE]->(en_l)\n");
        query.push_str("MERGE (id_w)-[:HAS_LANGUAGE]->(id_l)\n");
        query.push_str("MERGE (de_w)-[:HAS_LANGUAGE]->(de_l)\n");

        query.push_str("MERGE (id_w)-[:TRANSLATES_TO]-(en_w)\n");
        query.push_str("MERGE (id_w)-[:TRANSLATES_TO]-(de_w)\n");
        query.push_str("MERGE (de_w)-[:TRANSLATES_TO]-(en_w)\n");

        query.push_str("MERGE (de_w)-[:EXPRESSES]->(c)\n");
        query.push_str("MERGE (id_w)-[:EXPRESSES]->(c)\n");
        query.push_str("MERGE (en_w)-[:EXPRESSES]->(c)\n");

        return query;
    }
}