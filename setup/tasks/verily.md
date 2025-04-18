# Verily Project Tasks - Action Verification Platform

**Date Created:** 2024-07-27

**AI Assistant Note:** Remember to check off tasks here as they are completed. Update this list frequently to reflect the current project state.

**Current Focus (as of 2025-04-11):** Development is primarily focused on implementing core frontend features and specific action types within the `Verily` mobile application (Phase 3). Backend and `Verily Create` tasks are secondary priorities for now.

## Phase 1: Foundation & Backend Setup (Serverpod)

- [x] **Project Structure:**
  - [x] Create/Verify initial monorepo directory structure (`/apps`, `/packages`, `/backend`, `/setup`, etc.).
  - [x] Initialize `fvm` for Flutter version management.
  - [x] Create Serverpod project in `/backend` (`serverpod create verily`). This will create `verily_server`, `verily_client`, `verily_flutter`.
- [x] **Backend Dependencies (in `/backend/verily_server/pubspec.yaml`):**
  - [x] Verify core Serverpod dependencies (`serverpod`).
  - [ ] Add required Serverpod modules (e.g., `serverpod_auth_server`, `serverpod_auth_email_server`, `serverpod_postgres`). *_(Marking as potentially incomplete - needs verification)_*
- [x] **Serverpod Backend Setup:**
  - [x] Configure database connection in `config/development.yaml` and `config/production.yaml`.
  - [x] Securely configure `config/passwords.yaml` (add to `.gitignore`!).
  - [x] Define initial data models in `lib/src/models/*.spy.yaml`. *_(Action, Step, Webhook, Location, Creator models defined)_*
  - [x] Run `serverpod generate` to create initial protocol, client, and database classes. *_(Ran multiple times, including after adding LocationEndpoint and step methods)_*
  - [x] Create initial database migrations (`serverpod create-migration`). *_(Created 20250411181227186)_*
  - [x] Apply migrations (`dart bin/main.dart --apply-migrations -r maintenance`). *_(Applied 20250411181227186)_*
  - [x] Define initial Endpoints in `lib/src/endpoints/`. *_(Action, Location endpoints created. Webhook endpoint pending)_*
  - [ ] Implement basic health check endpoint. *_(Needs verification)_*
- [ ] **Database Schema Definition (via `*.spy.yaml` files):**
  - [x] Define structure for `Action` class.
  - [x] Define structure for `ActionStep` class.
  - [x] Define structure for `Creator` class (consider leveraging `serverpod_auth` module's `UserInfo`).
  - [x] Define structure for `Webhook` class.
  - [x] Define structure for `VerificationAttempt` class.
  - [x] *Task:* Fix model relation and index definitions in `*.spy.yaml` files. *_(Completed)_*
  - [x] *Task:* Create `location.spy.yaml` model. *_(Completed)_*
  - [x] *Task:* Update `action.spy.yaml` model with location, time constraints, and ordering fields. *_(Completed)_*
  - [x] *Task:* Manage schema changes and migrations using `serverpod generate`. *_(Generate successful)_*
  - [x] *Task:* Manage schema changes and migrations using `serverpod create-migration`. *_(Created 20250411181227186)_*
  - [x] *Task:* Manage schema changes and migrations using apply migrations. *_(Applied 20250411181227186)_*
- [x] **Core Backend API (Serverpod Endpoints):**
  - [x] Implement Endpoints for CRUD operations on `Action`. *_(Create, GetMy, GetDetails, Update, Delete implemented)_*
  - [x] Implement Endpoints for CRUD operations on `ActionStep`. *_(Add, Update, Delete implemented)_*
  - [ ] Implement Endpoints for CRUD operations on `Webhook`. *_(Not started)_*
  - [x] Implement Endpoint to get available `Location`s. *_(getAvailableLocations implemented)_*
  - [ ] Implement authentication for creator-specific Endpoints using `serverpod_auth`.
- [x] **Serverpod Client Usage:**
  - [x] Note: The Dart client is automatically generated in `/backend/verily_client`. Flutter apps will depend on this package.
  - [x] Configure the `Client` object in Flutter apps to connect to the Serverpod backend. *_(Done in verily_create/main.dart)_*
- [x] **Remove Old Backend Code:**
  - [x] Delete any existing Deno/TypeScript code/files within the `/backend` directory.
  - [x] Search codebase for Deno/tRPC specific terms and remove references.

## Phase 2: `Verily Create` Application (Web)

- [x] **Flutter Web Setup:**
  - [x] Initialize/Verify Flutter web project in `/apps/verily_create`.
  - [x] Configure Riverpod state management. *_(Setup complete)_*
  - [x] Set up basic navigation/routing. *_(Replaced Navigator with GoRouter for URL-based routing)_*
  - [x] Verify/Add frontend dependencies for Serverpod & Auth.
- [x] **Creator Authentication UI:**
  - [x] Implement login/signup UI using `serverpod_auth_email_flutter`. *_(SignInPage exists, integrated with GoRouter redirect)_*
- [x] **Action Management UI:**
  - [x] List existing actions. *_(Completed via ActionListPage)_*
  - [x] Form to create/edit actions (name, description, location, time, order). *_(Create implemented with location dropdown. Edit page exists but form fields not yet editable)_*
  - [x] Interface to add/edit/reorder action steps (selecting type, configuring parameters). *_(Add/Edit/Delete steps implemented. Reorder needed)_*
  - [ ] Interface to manage webhooks for actions.
  - [ ] Display generated Action URL/QR code.
- [x] **Serverpod Integration:**
  - [x] Add dependency on the generated `verily_client` package.
  - [x] Initialize the Serverpod `Client`.
  - [x] Connect UI components to backend Serverpod Endpoints. *_(Action list, create/edit action details (partially), add/edit/delete step, location list connected)_*

## Phase 3: `Verily` Application (Mobile)

- [ ] **Flutter Mobile Setup:**
  - [ ] Initialize/Verify Flutter mobile project in `/apps/verily`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation.
- [ ] **Permissions Handling (using `permission_handler`):**
    - [ ] Implement clear, contextual requests for Fine Location (Always/Foreground).
    - [ ] Implement clear, contextual requests for Camera (Front/Back).
    - [ ] Implement clear, contextual requests for Bluetooth (Scan, Connect).
    - [ ] Implement clear, contextual requests for Microphone.
    - [ ] Implement UI to handle permission denial gracefully (guide user to settings).
    - [ ] Add tests for permission request flows.
- [ ] **Core Sensor/Input Implementation:**
    - [ ] Implement continuous fine location tracking service (foreground/background).
    - [ ] Implement camera service/widget with front/back camera switching.
    - [ ] Implement Bluetooth scanning for nearby devices (using `flutter_blue_plus` or similar).
    - [ ] Implement microphone access and basic audio capture for speech recognition (using `speech_to_text` or similar).
    - [ ] Add tests for core sensor interactions.
- [ ] **ML Implementation:**
    - [ ] Integrate `google_mlkit_face_detection` for smile detection.
    - [ ] Add tests for smile detection logic.
- [ ] **Action Initiation:**
  - [ ] Implement QR code scanner.
  - [ ] Implement deep link handling.
  - [ ] Fetch action details via Serverpod Endpoint using URL/ID (or use dummy data initially).
- [ ] **UI Development (Adhering to `ui_requirements.md`):**
    - [ ] Create UI screen to display available (dummy) action lists.
    - [ ] Create UI screen(s) for step-by-step action execution flow.
    - [ ] Implement reusable progress bar component for action lists.
    - [ ] Integrate camera preview into the action execution UI.
    - [ ] Design and implement feedback mechanisms for location, smile, and speech actions.
    - [ ] Add widget tests for new UI components.
- [ ] **Action Logic Implementation:**
    - [ ] Implement "Be at location" action logic (compare current location to target).
    - [ ] Implement "Smile at camera" action logic (using smile detection).
    - [ ] Implement "Say 'Encode is amazing!'" action logic (using speech recognition).
    - [ ] Add tests for action logic handlers.
- [ ] **Dummy Data Setup:**
    - [x] Define data structures for mock Action Lists and Steps.
    - [x] Create several dummy action lists including the specified actions ("Be at location", "Smile at camera", "Say Encode is amazing!").
    - [ ] Implement loading/display of dummy data in the UI. *_(Need to ensure dummy data uses locations added to backend)_*
- [ ] **Core Verification Packages Implementation:**
  - [ ] Create/refine/verify `verily_location` package.
  - [ ] Create/refine/verify `verily_face_detection` package.
  - [ ] Create/refine/verify `verily_device_motion` package.
  - [ ] Integrate packages into the Verily app's step execution logic.
- [ ] **Verification Reporting (via Serverpod Endpoints):**
  - [ ] Call Serverpod Endpoints to send step completion/final status updates to the backend.

## Phase 4: Webhooks & Final Integration

- [ ] **Backend Webhook Dispatch Logic:**
  - [ ] Implement logic within Serverpod Endpoints (or Serverpod Futures called by them) to trigger webhooks based on verification status updates.
  - [ ] Implement signing mechanism for webhooks.
  - [ ] Implement basic retry logic (potentially using Serverpod Futures).
- [ ] **`Reflexy` Demo App Update:**
  - [ ] Ensure `Reflexy` consumes the latest versions of `verily_*` packages.
  - [ ] Update `Reflexy` to showcase relevant verification types.
- [ ] **Testing:**
  - [ ] Write unit tests for backend Serverpod Endpoints/logic (Dart).
  - [ ] Write unit/widget tests for Flutter apps/packages.
  - [ ] Perform manual E2E testing.

## Phase 5: Polish & Future Considerations

- [ ] Refine UI/UX based on `ui_requirements.md` (animations, styling).
- [ ] Implement chosen authentication methods fully.
- [ ] Add analytics features.
- [ ] ~~Plan and execute migration from JSON storage to a database (SQLite/PostgreSQL).~~ (Serverpod uses PostgreSQL by default).
- [ ] Documentation refinement.

---

_This task list is dynamic and subject to change as the project evolves._
