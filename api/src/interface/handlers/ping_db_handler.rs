use axum::http::StatusCode;

pub async fn ping_db_handler() -> StatusCode {
    StatusCode::OK
}