pub use error::*;

mod error;

pub mod prelude {
    #[cfg(feature = "ssr")]
    pub use leptos::prelude::provide_context;
    pub use leptos::prelude::server;
    #[cfg(feature = "ssr")]
    pub use leptos::prelude::use_context;
    #[cfg(feature = "ssr")]
    pub use leptos_axum::extract;
    #[cfg(feature = "ssr")]
    pub use leptos_axum::extract_with_state;
}
