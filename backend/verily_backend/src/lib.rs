use axum::extract::FromRef;
use leptos::config::LeptosOptions;
use leptos::config::get_configuration;
use verily_core::AppError;
use verily_core::AppResult;
use verily_db::Db;
use verily_db::setup_memory_db;

#[derive(FromRef, Debug, Clone)]
pub struct AppState {
    pub leptos: LeptosOptions,
    pub db: Db,
}

impl AppState {
    pub async fn try_new() -> AppResult<Self> {
        let leptos = get_configuration(None)
            .map_err(|e| AppError::Other(e.to_string()))?
            .leptos_options;
        let db = setup_memory_db().await?;

        Ok(Self { leptos, db })
    }
}
