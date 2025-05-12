
pub mod migrations;

use neo4rs::{ConfigBuilder, Graph};

pub async fn connect() -> Graph {
        // Load environment variables from .env file
        let uri = std::env::var("NEO4J_URI").expect("NEO4J_URI environment variable not set");
        let user = std::env::var("NEO4J_USER").expect("NEO4J_USER environment variable not set");
        let password =
            std::env::var("NEO4J_PASSWORD").expect("NEO4J_PASSWORD environment variable not set");
        let db = std::env::var("NEO4J_DB").expect("NEO4J_DB environment variable not set");

        // Create a new Neo4j connection
        let config = ConfigBuilder::default()
            .uri(uri)
            .user(user)
            .password(password)
            .db(db)
            .fetch_size(500)
            .max_connections(10)
            .build()
            .unwrap();

        let graph = Graph::connect(config).await.unwrap();

        return graph;
    }

