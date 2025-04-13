<p align="center">
  <img src="assets/verily.svg" alt="Verily Logo" width="200"/>
</p>

# Verily: Real-World Action Verification

[![Flutter CI](https://github.com/ifiokjr/verily/actions/workflows/ci.yaml/badge.svg)](https://github.com/ifiokjr/verily/actions/workflows/ci.yaml)

**Verily** is a platform designed to reliably verify that specific actions have been performed in the real world. Using mobile device sensors (like camera, GPS, accelerometer) and on-device machine learning, Verily enables the creation and execution of verifiable action flows.

Imagine verifying event check-ins with a specific pose, confirming fitness challenge completion through motion tracking, or ensuring participation in a marketing campaign by visiting a location and smiling. Verily makes these scenarios possible.

## 🤔 Why Open Source?

Trust is paramount when dealing with sensor data. Verily is open-source for a few key reasons:

1.  **Transparency:** Anyone can inspect the code to understand exactly what data is collected, how it's processed, and where it goes. No black boxes.
2.  **Verifiability:** You (and AI tools) can analyze the codebase to confirm it only performs the necessary functions for action verification, ensuring no unintended data usage.
3.  **Community Collaboration:** Open development fosters innovation and allows the community to contribute, improve, and audit the platform.

## 🏗️ Project Structure (Monorepo)

This project uses a monorepo structure managed by [Melos](https://github.com/invertase/melos). Key directories include:

-   `/apps`: Contains the main applications.
    -   `verily_create`: (Future) Flutter web app for creators to design action flows.
    -   `verily`: The primary Flutter mobile app (iOS/Android) for end-users performing actions.
    -   `reflexy`: A demo game app showcasing package usage.
-   `/packages`: Reusable Flutter packages encapsulating sensor/ML logic (e.g., `verily_location`, `verily_face_detection`).
-   `/backend`: The [Serverpod](https://serverpod.dev/) backend project handling data persistence, API logic, and webhook management.
-   `/setup`: Project documentation, requirements, and task tracking.

## 🛠️ Technology Stack

-   **Frontend (Mobile & Web):** [Flutter](https://flutter.dev/)
-   **Backend:** [Dart](https://dart.dev/) with [Serverpod](https://serverpod.dev/)
-   **Database:** PostgreSQL (managed by Serverpod)
-   **Machine Learning:** On-device via [Google ML Kit](https://developers.google.com/ml-kit) Flutter plugins.
-   **Monorepo Management:** [Melos](https://github.com/invertase/melos)
-   **Flutter Version Management:** [FVM](https://fvm.app/)

## 🚀 Getting Started

This guide will help you set up the development environment. We recommend using [Visual Studio Code (VS Code)](https://code.visualstudio.com/) with the Flutter and Dart extensions for the best experience.

**Prerequisites:**

*   **Docker:** Ensure Docker Desktop is installed and running, as Serverpod relies on it for the development database. [Install Docker](https://docs.docker.com/get-docker/).

**Setup Steps:**

1.  **Install Flutter using FVM:**
    We use FVM (Flutter Version Management) to ensure consistent Flutter versions. Follow the [FVM installation guide](https://fvm.app/documentation/getting-started/installation) for your OS (Homebrew recommended for macOS).
    Once FVM is installed, enable the version specified in the project (check `fvm use` or `.fvm/fvm_config.json` if needed, but often `fvm install` followed by `fvm use` within the project is sufficient).

2.  **Install Project Dependencies:**
    Navigate to the root project directory in your terminal and run:
    ```bash
    flutter pub get
    ```
    *Note: If you encounter issues, ensure FVM is active by prefixing commands with `fvm`, e.g., `fvm flutter pub get`.*

3.  **Install CLI Tools (Melos & Serverpod):**
    Activate the specific versions used by the project:
    ```bash
    dart pub global activate melos 7.0.0-dev.8
    dart pub global activate serverpod_cli 2.5.1
    ```

4.  **Bootstrap Monorepo Packages:**
    Link the local packages together using Melos:
    ```bash
    melos bootstrap
    ```

5.  **Start the Backend Server:**
    Make sure Docker Desktop is running.
    Run the Serverpod backend using the Melos script:
    ```bash
    melos run server:start
    ```
    This command does the following:
    *   Navigates to the `packages/verily_server` directory.
    *   Starts the Docker containers (PostgreSQL database, Redis cache).
    *   Applies any pending database migrations.
    *   Starts the Serverpod Dart server.
    *Keep this terminal window running.*

6.  **Run the Verily Mobile App:**
    In a **new** terminal window:
    ```bash
    cd apps/verily
    flutter run
    ```
    Select a connected device or simulator when prompted.

**Optional Setup:**

*   **Shorebird (Code Push):** For over-the-air updates. Follow the [Shorebird initialization guide](https://docs.shorebird.dev/code-push/initialize/) if you plan to use this feature.

## 🙌 Contributing

Contributions are welcome! Please feel free to:

*   Report bugs or suggest features by opening an issue.
*   Submit pull requests for improvements or bug fixes.

For major changes, please open an issue first to discuss the proposed changes.

---

*This README is actively maintained. If you find discrepancies or outdated information, please raise an issue.*
