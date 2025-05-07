use axum::http::StatusCode;

pub async fn ping_api_handler() -> StatusCode {
    StatusCode::OK
}
