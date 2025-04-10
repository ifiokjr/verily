use std::collections::HashMap;
use std::fs::File;
use std::io::BufReader;
use std::io::Read;
use std::path::Path;

use verily_core::DbError;
use verily_core::DbResult;
use serde::Deserialize;
use serde::Serialize;
use serde_json::Deserializer;
use solana_sdk::pubkey::Pubkey;
use uuid::Uuid;
use welds::Client;
use welds::check::Issue;
use welds::model_traits::HasSchema;
use welds::model_traits::TableColumns;
use welds::model_traits::TableInfo;


/// Setup a new in-memory database primary for testing.
pub async fn setup_memory_db() -> DbResult<Db> {
	let db = Db::try_new("sqlite::memory:").await?;
	sqlx::migrate!("../../migrations")
		.run(db.as_sqlx_pool())
		.await?;

	Ok(db)
}

pub async fn get_schema_issues<T>(db: &Db) -> DbResult<Vec<Issue>>
where
	T: Send + HasSchema,
	<T as HasSchema>::Schema: TableInfo + TableColumns,
{
	let issues = welds::check::schema::<T>(db.as_ref())
		.await?
		.into_iter()
		.filter(|issue| {
			match issue.kind {
				welds::check::Kind::Changed(ref diff) => {
					let db_type = diff.db_type.as_str();
					let welds_type = diff.welds_type.as_str();
					println!("db_type: {db_type}");
					println!("welds_type: {welds_type}");
					println!("welds_type == db_type: {}", welds_type == db_type);

					if diff.db_nullable != diff.welds_nullable {
						true
					} else if db_type == "TEXT" {
						!["DateTime<Utc>", "NaiveDate"].contains(&welds_type)
					} else if db_type == "INTEGER" {
						![
							"bool",
							"i16",
							"i32",
							"i64",
							"i8",
							"u16",
							"u32",
							"u8",
							"ActorType",
							"AssetType",
							"AuthTokenType",
							"ExchangeableType",
							"UsernameStatus",
							"TaggableType",
							"TagStatus",
							"UserRegistrationStatus",
							"VerificationType",
							"SetterType",
						]
						.contains(&welds_type)
					} else if db_type == "BLOB" {
						!["i128", "U64", "I128", "U128", "U64F64", "I64F64"].contains(&welds_type)
					} else {
						true
					}
				}
				_ => true,
			}
		})
		.collect();

	Ok(issues)
}
