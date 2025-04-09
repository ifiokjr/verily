# Verily Technical Requirements

This document details the technical specifications, architecture, and technologies for the Verily ecosystem.

## 1. Architecture Overview

Verily employs a monorepo structure containing distinct applications and shared packages.

- **`/apps`:** Contains the end-user applications.
  - `verily`: The primary Flutter application for action verification.
  - `reflexy`: The Flutter demo game application.
- **`/packages`:** Contains reusable Flutter components (packages and potentially modules).
  - `verily_sdk`: Flutter Module aggregating core functionalities for embedding.
  - `verily_device_motion`: Package for accelerometer/gyroscope access and verification.
  - `verily_face_detection`: Package for ML Kit face detection.
  - `verily_pose_detection`: Package for ML Kit pose detection (body landmarks).
  - `verily_location`: Package for GPS/location verification.
  - `verily_camera`: Core camera handling utilities (used by other vision packages).
  - `verily_audio`: Package for microphone access and basic audio analysis/verification (if needed).
  - (Potentially others: `verily_nfc`, `verily_bluetooth`, `verily_barcode_scanning`, `verily_text_recognition`, `verily_object_detection`, etc., based on ML Kit capabilities and use cases).
- **`/backend` (Conceptual):** Contains the Rust backend service.
- **`/specs`:** Contains specification documents.

## 2. Frontend (Flutter)

### 2.1. Applications (`/apps`)

- **Platform:** Flutter (using `fvm` for version management).
- **State Management:** Riverpod (Leveraging the `flutter` rule).
- **Core Dependencies:**
  - `flutter_riverpod`
  - Dependencies on relevant `/packages/verily_*` packages.
  - `permission_handler`: For requesting sensor permissions.
  - `uni_links` or similar: For handling deep linking to open the `Verily` app.
  - `http` or `dio`: For communication with the backend (if the Verily app needs to directly call back).
- **Build/Distribution:** Standard Flutter build processes. Consider Shorebird for future over-the-air updates.

### 2.2. Packages (`/packages`)

- **Type:** Primarily Flutter Packages, except for `verily_sdk` which is a Flutter Module.
- **Purpose:** Encapsulate specific sensor access and ML verification logic.
- **Key Dependencies (within relevant packages):**
  - `google_ml_kit_*` suite (e.g., `google_mlkit_face_detection`, `google_mlkit_pose_detection`).
  - `sensors_plus` (in `verily_device_motion`).
  - `geolocator` (in `verily_location`).
  - `camera` (core dependency, likely managed in `verily_camera` or directly in vision packages).
  - Potentially `nfc_manager`, `flutter_blue_plus`, `flutter_nearby_connections`, etc., for respective packages.
- **Design:** Packages should expose a clear, high-level API for initiating monitoring/verification and returning results (e.g., `Future<bool> verifySmile()`, `Stream<DeviceRotation> monitorRotation()`).

### 2.3. Verily SDK (`/packages/verily_sdk`)

- **Type:** Flutter Module.
- **Purpose:** Provide a single integration point for native applications.
- **Functionality:** Acts as a facade, importing and re-exporting the APIs of the individual `verily_*` packages. It will need platform channel implementations (or potentially FFI via `flutter_rust_bridge` if interacting with Rust logic directly) to expose its functionality to the native host (Android/iOS).
- **Integration:** Developers integrating the SDK into native apps will use standard Flutter module integration methods (e.g., `FlutterEngine`, `MethodChannel` on Android/iOS).

## 3. Backend

- **Language:** Rust
- **Async Runtime:** Tokio
- **Web Framework:** Axum (preferred for building the API and potentially the developer portal).
- **API Layer:** An HTTP API for:
  - Developer authentication (API key validation).
  - Defining/managing verification flows.
  - Receiving verification completion notifications from the Verily app.
  - Potentially serving the "Install Verily" webpage.
- **Server Functions (`server_fn`):** While initially considered, using `axum` for a dedicated backend API seems more appropriate for managing developer state, API keys, and persistent webhook configurations. `server_fn` might be less suitable for this stateful, multi-tenant backend scenario compared to a traditional web framework.
- **Database:** SQLite initially (using `sqlx`). Consider PostgreSQL for future scalability.
  - **Schema:** Tables for developers, API keys, verification flow definitions, registered webhooks, potentially audit logs of verification events.
- **Authentication:** `oxide-auth` or custom implementation for developer portal login (if built). API key validation for API requests.
- **Webhook Dispatch:** Robust mechanism to send signed POST requests to developer-registered webhook URLs upon verification completion. Needs retry logic.
- **Serialization:** Serde
- **Logging/Tracing:** `tracing`, `log`.
- **Deployment:** Containerized deployment (Docker) to a cloud platform (e.g., Fly.io, Google Cloud Run, AWS Fargate).

## 4. Machine Learning

- **Primary:** Google ML Kit suite via Flutter plugins for on-device analysis.
  - Face Detection
  - Pose Detection
  - Consider others: Text Recognition, Barcode Scanning, Object Detection, Selfie Segmentation based on defined verification actions.
- **Secondary:** Core ML (iOS) / TensorFlow Lite (Android/general) - Only if custom models or specific platform optimizations are absolutely necessary, as this increases complexity significantly.

## 5. Testing Strategy

- **Unit Tests (Dart/Flutter):** For business logic within packages and apps (view models, state management logic, utility functions).
- **Widget Tests (Flutter):** For UI components in isolation.
- **Integration Tests (Flutter):** Limited use due to hardware dependency. Can test app navigation and state flow with mocked sensor/ML data.
- **Manual Testing (via `Reflexy`):** Primary method for testing core sensor and ML verification functionality on physical devices.
- **Backend Tests (Rust):** Unit and integration tests for API endpoints, database interactions, and webhook logic.
- **End-to-End (E2E):** Complex to automate fully. Manual E2E tests involving a developer app -> backend -> Verily App -> backend -> webhook notification flow are necessary.
