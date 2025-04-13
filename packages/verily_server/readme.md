# Verily Server (`packages/verily_server`)

This directory contains the Serverpod backend server for the Verily platform. It handles API requests from the client applications, interacts with the PostgreSQL database, manages authentication, and executes core business logic.

## Getting Started

1.  **Prerequisites:** Ensure you have completed the main setup steps outlined in the [root README.md](../../README.md), including installing Docker, FVM/Flutter, the Serverpod CLI, and Melos.
2.  **Dependencies:** Dependencies are managed via `pubspec.yaml` in this directory, but typically installed via `melos bootstrap` from the root.
3.  **Running the Server:** The server is best run using the Melos script from the **root directory** of the monorepo. Make sure Docker Desktop is running first:
    ```bash
    # From the monorepo root
    melos run server:run
    ```
4.  **Development:**
    *   **Model Changes:** If you modify or add `.spy.yaml` files in `lib/src/models/`, you need to regenerate the server code and client library. Run `serverpod generate` within this directory or, preferably, ensure a Melos script exists for this in the root `pubspec.yaml`.
    *   **Database Migrations:** After model changes affecting the database, create and apply migrations using the Serverpod CLI (ensure the server is stopped first if running standalone, though the `server:run` script handles applying migrations):
        ```bash
        # Within packages/verily_server
        serverpod create-migration
        dart bin/main.dart --role maintenance --apply-migrations
        ```

See the [Serverpod Documentation](https://docs.serverpod.dev/) for more details on developing with Serverpod.
