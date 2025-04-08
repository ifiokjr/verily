# Verily Product Requirements

This document outlines the product requirements for the Verily ecosystem, encompassing the end-user application, a demonstration game, and a developer SDK.

## 1. Overall Vision

Verily provides a robust framework for verifying real-world user actions through mobile device sensors and on-device machine learning. It aims to offer a secure and reliable way for applications and services to confirm user-performed tasks, ranging from simple gestures to complex activities.

## 2. Core Products

The Verily ecosystem consists of three main components:

### 2.1. `Verily` App (End-User Application)

- **Purpose:** The primary mobile application installed by end-users to perform and verify actions requested by third-party applications or services.
- **Core Functionality:**
  - Guides users through specific action sequences ("verification flows").
  - Utilizes device sensors (camera, motion, location, etc.) and ML Kit for verification.
  - Provides clear instructions and real-time feedback.
- **Interaction Flow:**
  1. A third-party app/website initiates a verification request via a deep link/URL specific to Verily.
  2. If the Verily app is installed, it opens and presents the required action(s) to the user.
  3. If the Verily app is _not_ installed, the user is directed to a webpage (hosted by the Verily backend) with instructions on how to install the app (App Store/Play Store links).
  4. Upon successful completion (or failure) of the action(s), the Verily app securely sends a completion status back to the originating app/service via a predefined callback URL or mechanism provided in the initial request.
- **User Data:** Primarily handles ephemeral data related to the current verification task. User account management might be considered for future versions but is not required initially.

### 2.2. `Reflexy` Game (Demo Application)

- **Purpose:** A mobile game built using the Verily packages to demonstrate the capabilities of the verification framework and serve as a testbed during development.
- **Functionality:** Presents users with a series of increasingly complex challenges requiring sensor interaction (e.g., tilt device, make a face, hold a pose) verified by the underlying Verily packages.
- **Technology:** Built with Flutter, initially using plugins directly, later refactored to use the official `verily_*` packages. Located in `/apps/reflexy`.

### 2.3. `Verily SDK` (Developer SDK)

- **Purpose:** Allows third-party developers to integrate Verily's action verification capabilities into their own applications (mobile, web, backend).
- **Format:** A Flutter Module (`/packages/verily_sdk`) designed to be embeddable into native Android and iOS applications. Explores potential for integration with other frameworks like React Native/Expo.
- **Functionality:**
  - Aggregates and exposes the functionalities of the individual `verily_*` sensor/ML packages through a unified API.
  - Provides methods for developers to:
    - Define or select predefined verification flows.
    - Initiate a verification request for a user (generating the deep link/URL for the Verily App).
    - Potentially receive verification results directly if used embedded within an app (though the primary mechanism is the Verily App -> Backend -> Webhook flow).
- **Distribution:** Likely distributed through standard package managers (Pub.dev for Flutter components, potentially Maven/CocoaPods wrappers for native).

## 3. Third-Party Developer Integration & Backend

- **Purpose:** Enable developers to leverage Verily for verifying actions within their own applications/services.
- **Developer Portal (Conceptual):** A web interface where developers can register, obtain API/SDK keys, define custom verification flows (or use templates), and register webhook endpoints.
- **API Keys:** Secure keys used by developers to authenticate requests with the Verily backend API.
- **Verification Process:**
  1. Developer's backend uses its API key to request a verification flow from the Verily backend API, specifying the actions and a callback identifier/webhook endpoint.
  2. Verily backend potentially validates the request and stores relevant details.
  3. Developer's application directs the end-user to the Verily App using the generated deep link/URL.
  4. End-user performs the action in the Verily App.
  5. The Verily App confirms completion locally and notifies the Verily backend.
  6. The Verily backend sends a signed notification (webhook) to the developer's registered endpoint, confirming the verification result (success/failure, potentially relevant metadata).
- **Backend:** A necessary component (likely Rust-based) to manage developer accounts, API keys, potentially store verification flow templates, handle Verily App callbacks, and dispatch webhooks.

## 4. Target Use Cases

- Enhanced KYC processes
- Secure Multi-Factor Authentication (MFA/2FA)
- Proof-of-Action for games or loyalty programs
- Proof-of-Presence or location check-ins
- Remote task verification (e.g., specific exercises for physiotherapy)
- Interactive marketing campaigns

## 5. Potential Future Ideas

- **AI Answer Verification:** Analyze speech and facial cues.
- **Lie Detector:** Experimental feature.
- **Advanced Location Verification:** Combine GPS with visual confirmation.
- **Complex Action Sequences:** Multi-step, conditional flows.
