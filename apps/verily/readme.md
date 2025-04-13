# Verily Mobile App (`apps/verily`)

This is the primary Flutter mobile application for end-users to perform and verify real-world actions defined via the Verily platform.

## Features

*   Initiates action flows via QR codes or deep links.
*   Guides users through multi-step verification processes.
*   Utilizes device sensors (camera, GPS, accelerometer) and ML Kit for verification.
*   Communicates with the Verily backend ([`packages/verily_server`](../../packages/verily_server)) via the generated client ([`packages/verily_client`](../../packages/verily_client)).
*   Leverages shared UI components and logic from `/packages`.

## Getting Started

1.  **Prerequisites:** Ensure you have completed the main setup steps outlined in the [root README.md](../../README.md), including installing Docker, FVM/Flutter, Serverpod CLI, Melos, and bootstrapping the monorepo (`melos bootstrap`).
2.  **Start the Backend:** Make sure the Verily Serverpod backend is running. From the **monorepo root**:
    ```bash
    melos run server:run
    ```
3.  **Run the App:** Navigate to this directory (`apps/verily`) in a **new terminal** and run:
    ```bash
    flutter run
    ```
    Select a connected Android/iOS device or simulator when prompted.

## Development Notes

*   State management is handled by Riverpod.
*   API calls are made using the `verily_client` package.
*   Ensure necessary sensor permissions are handled correctly (see `permission_handler` usage).
