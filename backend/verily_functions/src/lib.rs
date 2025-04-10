use verily_core::{AppError, prelude::*};

pub fn set_urls(api_url: String) {
    let url = Box::leak(api_url.into_boxed_str());
    server_fn::client::set_server_url(url);
}

#[server]
pub async fn hello_world() -> Result<String, AppError> {
    Ok("Hello, world!".to_string())
}
