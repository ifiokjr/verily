#[tokio::main]
async fn main() -> anyhow::Result<()> {
    use anyhow::Context;
    use axum::Router;
    use axum::routing::get;
    use leptos::prelude::*;
    use leptos_axum::LeptosRoutes;
    use tower_http::compression::CompressionLayer;
    use tower_http::compression::CompressionLevel;
    use tower_http::compression::Predicate;
    use tower_http::compression::predicate::NotForContentType;
    use tower_http::compression::predicate::SizeAbove;
    use verily_backend::AppState;
    #[allow(unused_imports)]
    use verily_functions::*;

    // initialize logging
    simple_logger::init_with_level(log::Level::Debug).context("couldn't initialize logging")?;

    let state = AppState::try_new().await?;
    let addr = state.leptos.site_addr;

    let predicate = SizeAbove::new(1500) // files smaller than 1501 bytes are not compressed, since the MTU (Maximum Transmission
        // Unit) of a TCP packet is 1500 bytes
        .and(NotForContentType::GRPC)
        .and(NotForContentType::IMAGES)
        // prevent compressing assets that are already statically compressed
        .and(NotForContentType::const_new("application/javascript"))
        .and(NotForContentType::const_new("application/wasm"))
        .and(NotForContentType::const_new("text/css"));

    // Define a simple hello world handler
    async fn hello_world() -> &'static str {
        "Hello, World!"
    }

    let app = Router::new()
        // Add a test route that returns "Hello, World!"
        .route("/hello", get(hello_world))
        .leptos_routes_with_context(
            &state,
            vec![],
            {
                let app_state = state.clone();
                move || {
                    provide_context(app_state.db.clone());
                    provide_context(app_state.leptos.clone());
                }
            },
            move || (),
        )
        .layer(
            CompressionLayer::new()
                .quality(CompressionLevel::Fastest)
                .compress_when(predicate),
        )
        .with_state(state);

    // run our app with hyper
    // `axum::Server` is a re-export of `hyper::Server`
    log::info!("listening on http://{}", &addr);
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();

    axum::serve(listener, app.into_make_service()).await?;

    Ok(())
}
