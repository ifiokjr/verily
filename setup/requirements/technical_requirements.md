# Verily Technical Requirements

This document details the technical specifications, architecture, and technologies for the Verily ecosystem.

## 1. Architecture Overview

Verily employs a monorepo structure containing distinct applications and shared packages.

- **`/apps`:** Contains the end-user applications.
  - `verily_create`: The Flutter web application for creators.
  - `verily`: The primary Flutter mobile application for action verification.
  - `reflexy`: The Flutter demo game application showcasing package usage.
- **`/packages`:** Contains reusable Flutter components and the tRPC client.
  - `verily_trpc`: Package housing the auto-generated Dart client for the tRPC API, using `trpc-client-dart`.
  - `verily_device_motion`: Package for accelerometer/gyroscope access and verification.
  - `verily_face_detection`: Package for ML Kit face detection.
  - `verily_pose_detection`: Package for ML Kit pose detection (body landmarks).
  - `verily_location`: Package for GPS/location verification.
  - `verily_camera`: Core camera handling utilities (used by other vision packages).
  - `verily_audio`: Package for microphone access and basic audio analysis/verification (if needed).
  - (Potentially others: `verily_nfc`, `verily_bluetooth`, `verily_barcode_scanning`, `verily_text_recognition`, `verily_object_detection`, etc., based on ML Kit capabilities and use cases).
- **`/backend`:** Contains the Deno backend service.
- **`/setup`:** Contains requirement documents, tasks, and setup scripts.
- **`/migrations`:** Contains database migration files (if using a persistent DB).

## 2. Frontend (Flutter)

### 2.1. Applications (`/apps`)

- **Platform:** Flutter (using `fvm` for version management).
- **State Management:** Riverpod (Leveraging the `flutter` rule).
- **API Communication:** Via the generated tRPC client in `packages/verily_trpc`.
- **Core Dependencies:**
  - `flutter_riverpod`
  - `trpc_client` (dependency within `verily_trpc` and potentially used directly in apps)
  - Dependencies on relevant `/packages/verily_*` sensor/ML packages.
  - `permission_handler`: For requesting sensor permissions.
  - `uni_links` or similar: For handling deep linking to open the `Verily` app.
- **Build/Distribution:** Standard Flutter build processes. Consider Shorebird for future over-the-air updates.

### 2.2. Packages (`/packages`)

- **Type:** Primarily Flutter Packages.
- **Purpose:** Encapsulate specific sensor access, ML verification logic, and the tRPC client.
- **Key Dependencies (within relevant packages):**
  - `google_ml_kit_*` suite (e.g., `google_mlkit_face_detection`, `google_mlkit_pose_detection`).
  - `sensors_plus` (in `verily_device_motion`).
  - `geolocator` (in `verily_location`).
  - `camera` (core dependency, likely managed in `verily_camera` or directly in vision packages).
  - Potentially `nfc_manager`, `flutter_blue_plus`, `flutter_nearby_connections`, etc., for respective packages.
- **Design:** Sensor/ML packages should expose a clear, high-level API. `verily_trpc` will contain the generated Dart client based on the backend's tRPC router definition.

### 2.3. Verily tRPC Package (`/packages/verily_trpc`)

- **Purpose:** Centralizes the type-safe communication layer with the Deno backend.
- **Generation:** Uses `trpc-client-dart` and `build_runner` to generate Dart models and router definitions directly from the backend's tRPC `AppRouter` type definition.
- **Dependencies:** `trpc_client`, `freezed_annotation`, `json_annotation`.
- **Build Dependencies:** `build_runner`, `freezed`, `json_serializable`, `trpc_client_generator`.

## 3. Backend (Deno + tRPC)

- **Runtime:** Deno
- **API Framework:** tRPC (`@trpc/server`)
- **Dependencies:**
    - `@trpc/server`, `@trpc/client` (for potential server-to-server calls if needed)
    - `zod` (for input validation)
    - Deno Standard Library (`std`)
- **Structure:** Follows standard tRPC structure:
    - Initialization (`trpc.ts`)
    - Router definitions (`router.ts` or similar, defining `AppRouter`)
    - Procedure implementations (queries and mutations)
    - Context creation (`context.ts`)
    - Server adapter (e.g., `standalone` or integrated with a Deno web framework like Oak if needed later)
- **Data Storage:**
    - **Initial:** File-based JSON storage (similar to the Deno/tRPC blog example) for rapid development.
    - **Future:** Migrate to SQLite or PostgreSQL using a Deno-compatible driver/ORM (e.g., `deno-sqlite`, `postgres`, potentially Drizzle ORM with a Deno adapter).
- **Schema:** (Applicable when using a database)
    - `Creators`: Stores creator information and authentication details.
    - `Actions`: Stores definition of verifiable actions (name, description, configuration).
    - `ActionSteps`: Stores individual steps within an action (type, parameters, order).
    - `Webhooks`: Stores creator-defined webhooks (URL, associated action/events, secret).
    - `VerificationAttempts`: Logs attempts to complete actions (user identifier, status, timestamps, progress).
- **Authentication:**
    - Creator authentication handled via tRPC middleware (e.g., checking API keys or session tokens passed in context).
    - User authentication within the Verily app (various methods) potentially managed via backend procedures.
- **Webhook Dispatch:** Logic within tRPC procedures or dedicated backend functions to send signed POST requests to registered webhook URLs upon verification events. Needs retry logic.
- **Deployment:**
    - Deno Deploy (ideal for serverless Deno apps)
    - Containerized deployment (Docker) to cloud platforms (Fly.io, Google Cloud Run, AWS Fargate, etc.)

## 4. Machine Learning

- **Primary:** Google ML Kit suite via Flutter plugins for on-device analysis.
  - Face Detection
  - Pose Detection
  - Consider others: Text Recognition, Barcode Scanning, Object Detection, Selfie Segmentation based on defined verification actions.
- **Secondary:** Core ML (iOS) / TensorFlow Lite (Android/general) - Only if custom models or specific platform optimizations are absolutely necessary.

## 5. Testing Strategy

- **Unit Tests (Dart/Flutter):** For business logic within Flutter packages and apps (view models, Riverpod providers, utility functions).
- **Widget Tests (Flutter):** For UI components in isolation.
- **Backend Tests (Deno/TypeScript):** Using Deno's built-in test runner (`deno test`) for tRPC procedures, data layer logic, and utility functions.
- **Integration Tests (Flutter):** Can test app navigation and state flow with mocked tRPC responses.
- **Manual Testing (via `Reflexy`):** Primary method for testing core sensor and ML verification functionality on physical devices.
- **End-to-End (E2E):** Manual E2E tests involving creator app -> backend -> Verily App -> backend -> webhook notification flow. Automated E2E might be possible using tools that can orchestrate backend and frontend interactions.
