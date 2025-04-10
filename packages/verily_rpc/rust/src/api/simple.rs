use verily_core::AppResult;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn set_urls(api_url: String) {
    verily_functions::set_urls(api_url);
}

/// Call a server function
pub async fn hello_world() -> AppResult<String>
{
    verily_functions::hello_world().await
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
