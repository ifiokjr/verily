use std::sync::Arc;

use derive_more::Debug;
use derive_more::Deref;
use derive_more::DerefMut;
use derive_more::From;
use derive_more::Into;
use verily_core::DbError;
use verily_core::DbResult;
use verily_core::prelude::use_context;
pub use welds::TransactStart;
use welds::connections::Transaction;
use welds::connections::sqlite::SqliteClient;
use welds::connections::sqlite::connect;

#[derive(Debug, Clone, From, Into, Deref, DerefMut)]
pub struct Db(#[debug(skip)] Arc<SqliteClient>);

impl Db {
    /// Create a new `Db` from a connection string.
    pub async fn try_new(connection_string: &str) -> DbResult<Self> {
        let connection = connect(connection_string).await?;

        Ok(Arc::new(connection).into())
    }

    /// Extract the `Db` from the context.
    pub fn from_context() -> DbResult<Self> {
        use_context::<Self>().ok_or(DbError::MissingContext)
    }

    /// Get the `sqlx::SqlitePool` from the `Db`.
    pub fn as_sqlx_pool(&self) -> &sqlx::SqlitePool {
        self.0.as_sqlx_pool()
    }

    /// Get the `SqliteClient` from the `Db`.
    pub fn as_client(&self) -> &SqliteClient {
        self.0.as_ref()
    }

    /// Get a new transaction from the `Db`.
    pub async fn transaction(&self) -> DbResult<Transaction> {
        let result = self.as_client().begin().await?;
        Ok(result)
    }
}
