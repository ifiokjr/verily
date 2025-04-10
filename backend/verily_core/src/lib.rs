use std::borrow::Cow;

use server_fn::ServerFnError;
use server_fn::error::FromServerFnError;
use server_fn::error::ServerFnErrorErr;
use serde::Deserialize;
use serde::Serialize;
use strum::AsRefStr;
use strum::Display as StrumDisplay;
use strum::EnumDiscriminants;
use strum::EnumIs;
use strum::EnumString;
use strum::IntoStaticStr;
use thiserror::Error as ThisError;
use uuid::Uuid;
use validator::ValidationErrors;


#[derive(ThisError, Debug, Clone, PartialEq, Serialize, Deserialize, EnumDiscriminants)]
#[serde(rename_all = "snake_case", tag = "type")]
#[strum(serialize_all = "snake_case")]
#[strum_discriminants(
	derive(
		Serialize,
		Deserialize,
		AsRefStr,
		EnumString,
		IntoStaticStr,
		StrumDisplay,
		EnumIs
	),
	name(AppErrorCode),
	serde(rename_all = "snake_case"),
	strum(serialize_all = "snake_case")
)]
pub enum AppError {
	#[error("Not connected to the network")]
	NotConnected,
	#[error("Unauthorized action: {action} on {id}")]
	UnauthorizedAction {
		action: Cow<'static, str>,
		id: Uuid,
		description: String,
	},
	#[error("Not found: {name} on {id}")]
	NotFound { name: Cow<'static, str>, id: Uuid },
	#[error("Already deleted: {name} on {id}")]
	AlreadyDeleted { name: Cow<'static, str>, id: Uuid },
	#[error("An access token is required")]
	AccessTokenRequired,
	#[error("Access token expired")]
	AccessTokenExpired,
	#[error("Access token invalid")]
	AccessTokenInvalid,
	#[error("Refresh token expired")]
	RefreshTokenExpired,
	#[error("Refresh token invalid")]
	RefreshTokenInvalid,
	#[error("Refresh token revoked")]
	RefreshTokenRevoked,
	#[error("Username not associated with an actor: {username}")]
	UsernameNotAssociatedWithActor { username: String },
	#[error("Username not available: {username}")]
	UsernameNotAvailable { username: String },
	#[error("User not found: {id}")]
	UserNotFound { id: Uuid },
	#[error("Registration challenge not found")]
	RegistrationChallengeNotFound,
	#[error("Registration challenge expired")]
	RegistrationChallengeExpired,
	#[error("Registration challenge invalid")]
	RegistrationChallengeInvalid,
	#[error("Missing context")]
	MissingContext,
	#[error("Environment variable missing: {variable}")]
	EnvMissing { variable: String },
	#[error("Environment variable invalid: {variable}")]
	EnvInvalid { variable: String },
	#[error("Database error: {0}")]
	Db(DbError),
	#[error("Serde: {0}")]
	Serde(String),
	#[error("Json: {0}")]
	Json(String),
	#[error("Request: {0}")]
	Request(String),
	#[error("JWT: {0}")]
	Jwt(String),
	#[error("Webauthn: {0}")]
	Webauthn(String),
	#[error("Validation errors: {0}")]
	Validation(#[from] ValidationErrors),
	#[error("ServerFnError: {0}")]
	ServerFn(ServerFnErrorErr),
	#[error("Other error: {0}")]
	Other(String),
	#[error("Error hidden from client")]
	Hidden,
}

impl AppError {
	/// Only show sensitive errors in development mode or on the server.
	pub fn should_show_sensitive_errors() -> bool {
		cfg!(feature = "ssr") || cfg!(debug_assertions)
	}

	/// Check if the error is an access token error. In these cases we should
	/// retry it.
	pub fn is_access_token_error(&self) -> bool {
		matches!(
			self,
			Self::AccessTokenRequired | Self::AccessTokenExpired | Self::AccessTokenInvalid
		)
	}

	/// Check if the error is a refresh token error.
	pub fn is_refresh_token_error(&self) -> bool {
		matches!(
			self,
			Self::RefreshTokenExpired | Self::RefreshTokenInvalid | Self::RefreshTokenRevoked
		)
	}

	/// Check if the error is an authentication error.
	pub fn is_auth_error(&self) -> bool {
		matches!(
			self,
			Self::AccessTokenRequired
				| Self::AccessTokenExpired
				| Self::AccessTokenInvalid
				| Self::RefreshTokenExpired
				| Self::RefreshTokenInvalid
				| Self::RefreshTokenRevoked
		)
	}

	/// Check if the error is a retryable.
	pub fn is_retryable(&self) -> bool {
		!self.is_auth_error()
	}
}

impl FromServerFnError for AppError {
	fn from_server_fn_error(value: ServerFnErrorErr) -> Self {
		Self::ServerFn(value)
	}
}

impl From<ServerFnError> for AppError {
	fn from(value: ServerFnError) -> Self {
		if Self::should_show_sensitive_errors() {
			Self::Other(value.to_string())
		} else {
			Self::Hidden
		}
	}
}

pub type AppResult<T> = Result<T, AppError>;

// Tell axum how to convert `AppError` into a response.
#[cfg(feature = "ssr")]
impl axum::response::IntoResponse for AppError {
	fn into_response(self) -> axum::response::Response {
		(
			http::StatusCode::INTERNAL_SERVER_ERROR,
			format!("App error: {self}"),
		)
			.into_response()
	}
}

impl From<anyhow::Error> for AppError {
	fn from(err: anyhow::Error) -> Self {
		if Self::should_show_sensitive_errors() {
			Self::Other(err.to_string())
		} else {
			Self::Hidden
		}
	}
}

impl From<serde_json::Error> for AppError {
	fn from(value: serde_json::Error) -> Self {
		Self::Json(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<reqwest::Error> for AppError {
	fn from(value: reqwest::Error) -> Self {
		Self::Request(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<webauthn_rs_core::error::WebauthnError> for AppError {
	fn from(value: webauthn_rs_core::error::WebauthnError) -> Self {
		if Self::should_show_sensitive_errors() {
			Self::Webauthn(value.to_string())
		} else {
			Self::Hidden
		}
	}
}

impl From<DbError> for AppError {
	fn from(value: DbError) -> Self {
		if Self::should_show_sensitive_errors() {
			Self::Db(value)
		} else {
			Self::Hidden
		}
	}
}

pub trait IntoAppError: std::error::Error {
	fn into_app_error(self) -> AppError;
}

impl<T: IntoAppError> From<T> for AppError {
	fn from(err: T) -> Self {
		err.into_app_error()
	}
}

#[cfg(feature = "ssr")]
impl From<jsonwebtoken::errors::Error> for AppError {
	fn from(source: jsonwebtoken::errors::Error) -> Self {
		if Self::should_show_sensitive_errors() {
			Self::Jwt(source.to_string())
		} else {
			Self::Hidden
		}
	}
}

#[derive(ThisError, Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum DbError {
	#[error("Missing context")]
	MissingContext,
	#[error("Password: {0}")]
	PasswordHash(String),
	#[error("Encryption: {0}")]
	Encryption(String),
	#[error("Keypair: {0}")]
	Keypair(String),
	#[error("Welds: {0}")]
	Welds(String),
	#[error("Welds: {0}")]
	WeldsConnection(String),
	#[error("Migration: {0}")]
	Migration(String),
	#[error("Type mismatch")]
	TypeMismatch,
	#[error("Required data not found")]
	NotFound,
	#[error("`{model}` with id: `{id}` not found")]
	ModelNotFound {
		model: Cow<'static, str>,
		id: String,
	},
	#[error("File: {0}")]
	File(String),
	#[error("Other: {0}")]
	Other(String),
	#[error("JSON: {0}")]
	Json(String),
}

pub type DbResult<T> = Result<T, DbError>;

#[cfg(feature = "ssr")]
macro_rules! impl_db_error_into_app_error {
	($($t:ty),*) => {
		$(impl IntoAppError for $t {
			fn into_app_error(self) -> AppError {
				if AppError::should_show_sensitive_errors() {
					AppError::Db(self.into())
				} else {
					AppError::Hidden
				}
			}
		})*
	};
}

#[cfg(feature = "ssr")]
impl_db_error_into_app_error!(
	// argon2::password_hash::Error,
	// aes_gcm_siv::aead::Error,
	welds::WeldsError,
	welds::connections::Error,
	sqlx::migrate::MigrateError
);

#[cfg(feature = "ssr")]
impl From<argon2::password_hash::Error> for DbError {
	fn from(value: argon2::password_hash::Error) -> Self {
		Self::PasswordHash(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<aes_gcm_siv::aead::Error> for DbError {
	fn from(value: aes_gcm_siv::aead::Error) -> Self {
		Self::Encryption(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<welds::WeldsError> for DbError {
	fn from(value: welds::WeldsError) -> Self {
		Self::Welds(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<welds::connections::Error> for DbError {
	fn from(value: welds::connections::Error) -> Self {
		Self::WeldsConnection(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<sqlx::migrate::MigrateError> for DbError {
	fn from(value: sqlx::migrate::MigrateError) -> Self {
		Self::Migration(value.to_string())
	}
}

#[cfg(feature = "ssr")]
impl From<std::io::Error> for DbError {
	fn from(value: std::io::Error) -> Self {
		Self::File(value.to_string())
	}
}

impl From<anyhow::Error> for DbError {
	fn from(value: anyhow::Error) -> Self {
		Self::Other(value.to_string())
	}
}

impl From<serde_json::Error> for DbError {
	fn from(value: serde_json::Error) -> Self {
		Self::Json(value.to_string())
	}
}
