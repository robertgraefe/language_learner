use axum::{
    Json,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde_json::Error as SerdeJsonError;
use serde_json::json;

#[derive(Debug)]
pub struct AppError {
    pub status: StatusCode,
    pub message: String,
}

impl AppError {
    pub fn new(status: StatusCode, message: &str) -> Self {
        Self {
            status,
            message: message.to_string(),
        }
    }

    pub fn new_status(status: StatusCode) -> Self {
        Self {
            status,
            message: String::new(),
        }
    }
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let body = Json(json!({
            "error": self.message,
        }));
        (self.status, body).into_response()
    }
}

impl From<anyhow::Error> for AppError {
    fn from(err: anyhow::Error) -> Self {
        AppError::new(StatusCode::INTERNAL_SERVER_ERROR, &err.to_string())
    }
}

impl From<SerdeJsonError> for AppError {
    fn from(e: SerdeJsonError) -> Self {
        AppError::new(StatusCode::BAD_REQUEST, &e.to_string())
    }
}
