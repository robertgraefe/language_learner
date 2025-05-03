#[derive(serde::Deserialize, serde::Serialize, Debug)]
pub struct Word {
    language: String,
    text: String,
}
