# Verily Create App (`apps/verily_create`)

This is the Flutter web application for creators to define, manage, and monitor verifiable action flows for the Verily platform.

**(Note: This application is currently under development and may have limited functionality.)**

## Features (Planned)

*   User authentication for creators.
*   Interface to create and edit multi-step action flows.
*   Configuration of action parameters (location, time limits, verification types).
*   Management of webhooks for status notifications.
*   Dashboard to view action completion rates and analytics.
*   Generation of shareable links/QR codes for end-users.
*   Communication with the Verily backend ([`packages/verily_server`](../../packages/verily_server)) via the generated client ([`packages/verily_client`](../../packages/verily_client)).

## Getting Started

1.  **Prerequisites:** Ensure you have completed the main setup steps outlined in the [root README.md](../../README.md), including installing Docker, FVM/Flutter, Serverpod CLI, Melos, and bootstrapping the monorepo (`melos bootstrap`).
2.  **Start the Backend:** Make sure the Verily Serverpod backend is running. From the **monorepo root**:
    ```bash
    melos run server:run
    ```
3.  **Run the App:** Navigate to this directory (`apps/verily_create`) in a **new terminal** and run:
    ```bash
    flutter run -d chrome
    ```
    This will launch the web application in a Chrome browser.

## Development Notes

*   State management is handled by Riverpod.
*   API calls are made using the `verily_client` package.
*   Routing is managed by `go_router`.
*   Authentication UI utilizes the `serverpod_auth_email_flutter` package.
