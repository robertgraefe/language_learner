use chrono::Utc;
use neo4rs::{Graph, query};
use std::sync::Arc;

pub async fn run_migrations(graph: &Arc<Graph>) -> Result<(), neo4rs::Error> {
    let migrations = vec![
        (
            "11052025_1_create_english",
            r#"
            MERGE (en:Language {code: 'en', name: 'English'});
        "#,
        ),
        (
            "11052025_2_create_indonesian",
            r#"
            MERGE (id:Language {code: 'id', name: 'Indonesian'});
        "#,
        ),
        (
            "11052025_3_create_german",
            r#"
            MERGE (de:Language {code: 'de', name: 'German'});
        "#,
        ),
        (
            "11052025_4_create_language_name_unique_constraint",
            r#"            
            CREATE CONSTRAINT unique_language_name IF NOT EXISTS
            FOR (l:Language) REQUIRE l.name IS UNIQUE;
        "#,
        ),
        (
            "11052025_5_create_language_code_unique_constraint",
            r#"
            CREATE CONSTRAINT unique_language_code IF NOT EXISTS
            FOR (l:Language) REQUIRE l.code IS UNIQUE;
        "#,
        ),
    ];

    for (name, cypher) in migrations {
        if !migration_applied(graph, name).await? {
            println!("Running migration: {}", name);
            graph.run(query(cypher)).await?;
            log_migration(graph, name).await?;
        }
    }

    Ok(())
}

async fn migration_applied(graph: &Arc<Graph>, name: &str) -> Result<bool, neo4rs::Error> {
    let mut result = graph
        .execute(query("MATCH (m:Migration {name: $name}) RETURN m").param("name", name))
        .await?;
    Ok(result.next().await?.is_some())
}

async fn log_migration(graph: &Arc<Graph>, name: &str) -> Result<(), neo4rs::Error> {
    let applied_at = Utc::now().to_rfc3339();
    let q = query("CREATE (:Migration {name: $name, applied_at: $applied_at})")
        .param("name", name)
        .param("applied_at", applied_at);
    graph.run(q).await?;
    Ok(())
}
