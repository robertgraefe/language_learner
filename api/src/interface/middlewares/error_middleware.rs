use axum::{body::Body, http::Request, middleware::Next, response::Response};

pub async fn error_middleware(req: Request<Body>, next: Next) -> Response {
    let response = next.run(req).await;

    // You can log or inspect the response here if needed
    if response.status().is_server_error() {
        println!("Server error: {}", response.status());
    }

    response
}
