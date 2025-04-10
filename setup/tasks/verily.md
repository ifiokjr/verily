# Verily Project Tasks - Action Verification Platform

**Date Created:** 2024-07-27

**AI Assistant Note:** Remember to check off tasks here as they are completed. Update this list frequently to reflect the current project state.

## Phase 1: Foundation & Backend Setup (Serverpod)

- [ ] **Project Structure:**
  - [ ] Create/Verify initial monorepo directory structure (`/apps`, `/packages`, `/backend`, `/setup`, etc.).
  - [ ] Initialize `fvm` for Flutter version management.
  - [ ] Create Serverpod project in `/backend` (`serverpod create verily`). This will create `verily_server`, `verily_client`, `verily_flutter`.
- [ ] **Backend Dependencies (in `/backend/verily_server/pubspec.yaml`):**
  - [ ] Verify core Serverpod dependencies (`serverpod`).
  - [ ] Add required Serverpod modules (e.g., `serverpod_auth_server`, `serverpod_auth_email_server`, `serverpod_postgres`).
- [ ] **Serverpod Backend Setup:**
  - [ ] Configure database connection in `config/development.yaml` and `config/production.yaml`.
  - [ ] Securely configure `config/passwords.yaml` (add to `.gitignore`!).
  - [ ] Define initial data models in `lib/src/models/*.spy.yaml`.
  - [ ] Run `serverpod generate` to create initial protocol, client, and database classes.
  - [ ] Create initial database migrations (`serverpod create-migration`) and apply them (`dart bin/main.dart --apply-migrations -r maintenance`).
  - [ ] Define initial Endpoints in `lib/src/endpoints/`.
  - [ ] Implement basic health check endpoint.
- [ ] **Database Schema Definition (via `*.spy.yaml` files):**
  - [ ] Define structure for `Action` class.
  - [ ] Define structure for `ActionStep` class.
  - [ ] Define structure for `Creator` class (consider leveraging `serverpod_auth` module's `UserInfo`).
  - [ ] Define structure for `Webhook` class.
  - [ ] Define structure for `VerificationAttempt` class.
  - [ ] *Task:* Manage schema changes and migrations using `serverpod generate` and `serverpod create-migration`.
- [ ] **Core Backend API (Serverpod Endpoints):**
  - [ ] Implement Endpoints for CRUD operations on `Action`.
  - [ ] Implement Endpoints for CRUD operations on `ActionStep`.
  - [ ] Implement Endpoints for CRUD operations on `Webhook`.
  - [ ] Implement authentication for creator-specific Endpoints using `serverpod_auth`.
- [ ] **Serverpod Client Usage:**
  - [ ] Note: The Dart client is automatically generated in `/backend/verily_client`. Flutter apps will depend on this package.
  - [ ] Configure the `Client` object in Flutter apps to connect to the Serverpod backend.
- [ ] **Remove Old Backend Code:**
  - [ ] Delete any existing Deno/TypeScript code/files within the `/backend` directory (e.g., `deno.jsonc`, `.ts` files, tRPC specific code).
  - [ ] Search codebase for Deno/tRPC specific terms (`@trpc`, `zod`, Deno std lib usage) and remove references in the backend context.

## Phase 2: `Verily Create` Application (Web)

- [ ] **Flutter Web Setup:**
  - [ ] Initialize/Verify Flutter web project in `/apps/verily_create`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation/routing.
- [ ] **Creator Authentication UI:**
  - [ ] Implement login/signup UI using `serverpod_auth_email_flutter` (or other chosen auth modules).
- [ ] **Action Management UI:**
  - [ ] List existing actions.
  - [ ] Form to create/edit actions (name, description).
  - [ ] Interface to add/edit/reorder action steps (selecting type, configuring parameters).
  - [ ] Interface to manage webhooks for actions.
  - [ ] Display generated Action URL/QR code.
- [ ] **Serverpod Integration:**
  - [ ] Add dependency on the generated `verily_client` package.
  - [ ] Initialize the Serverpod `Client`.
  - [ ] Connect UI components to backend Serverpod Endpoints.

## Phase 3: `Verily` Application (Mobile)

- [ ] **Flutter Mobile Setup:**
  - [ ] Initialize/Verify Flutter mobile project in `/apps/verily`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation.
- [ ] **Action Initiation:**
  - [ ] Implement QR code scanner.
  - [ ] Implement deep link handling.
  - [ ] Fetch action details via Serverpod Endpoint using URL/ID.
- [ ] **Action Execution Flow:**
  - [ ] Display action instructions/steps.
  - [ ] Implement UI for guiding user through each step.
  - [ ] Provide real-time feedback.
- [ ] **Core Verification Packages Implementation:**
  - [ ] Create/refine/verify `verily_location` package.
  - [ ] Create/refine/verify `verily_face_detection` package.
  - [ ] Create/refine/verify `verily_device_motion` package.
  - [ ] Integrate packages into the Verily app's step execution logic.
- [ ] **Verification Reporting (via Serverpod Endpoints):**
  - [ ] Call Serverpod Endpoints to send step completion/final status updates to the backend.
- [ ] **Permissions Handling:**
  - [ ] Implement robust permission requests using `permission_handler`.

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
