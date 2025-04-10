# Verily Project Tasks - Action Verification Platform

**Date Created:** 2024-07-27

**AI Assistant Note:** Remember to check off tasks here as they are completed. Update this list frequently to reflect the current project state.

## Phase 1: Foundation & Backend Setup

- [ ] **Project Structure:**
  - [ ] Create initial monorepo directory structure (`/apps`, `/packages`, `/backend`, `/setup`, etc.).
  - [ ] Initialize `fvm` for Flutter version management.
- [ ] **Database Schema (SQLite - Initial):**
  - [ ] Define schema for `Actions` table (ID, creator_id, name, description, steps, config, created_at, updated_at).
  - [ ] Define schema for `ActionSteps` table (ID, action_id, type, parameters, order).
  - [ ] Define schema for `Creators` table (ID, auth_details, created_at).
  - [ ] Define schema for `Webhooks` table (ID, creator_id, action_id, url, events, secret, created_at).
  - [ ] Define schema for `VerificationAttempts` table (ID, action_id, user_identifier, status, start_time, end_time, step_progress).
- [ ] **Rust Backend Setup:**
  - [ ] Initialize Rust project in `/backend`.
  - [ ] Add core dependencies (`axum`, `tokio`, `sqlx`, `serde`, `tracing`).
  - [ ] Set up basic Axum server structure.
  - [ ] Configure database connection pool (`sqlx::SqlitePool`).
  - [ ] Implement basic health check endpoint.
- [ ] **Core Backend API (`Verily Create` related):**
  - [ ] Implement CRUD endpoints for `Actions`.
  - [ ] Implement CRUD endpoints for `ActionSteps` (associated with an Action).
  - [ ] Implement CRUD endpoints for `Webhooks` (associated with a Creator/Action).
  - [ ] Set up basic API authentication/authorization for Creators (placeholder/simple key initially).
- [ ] **Update Technical Requirements:**
  - [ ] Reflect Rust/Axum/SQLX choices.
  - [ ] Detail the initial SQLite database schema.
  - [ ] Update backend API descriptions.

## Phase 2: `Verily Create` Application (Web)

- [ ] **Flutter Web Setup:**
  - [ ] Initialize Flutter web project in `/apps/verily_create`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation/routing.
- [ ] **Creator Authentication:**
  - [ ] Implement basic login/signup flow (details TBD based on chosen method).
- [ ] **Action Management UI:**
  - [ ] List existing actions.
  - [ ] Form to create/edit actions (name, description).
  - [ ] Interface to add/edit/reorder action steps (selecting type, configuring parameters).
  - [ ] Interface to manage webhooks for actions.
  - [ ] Display generated Action URL/QR code.
- [ ] **API Integration:**
  - [ ] Connect UI components to backend API endpoints.

## Phase 3: `Verily` Application (Mobile)

- [ ] **Flutter Mobile Setup:**
  - [ ] Initialize Flutter mobile project in `/apps/verily`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation.
- [ ] **Action Initiation:**
  - [ ] Implement QR code scanner.
  - [ ] Implement deep link handling.
  - [ ] Fetch action details from backend using URL/ID.
- [ ] **Action Execution Flow:**
  - [ ] Display action instructions/steps.
  - [ ] Implement UI for guiding user through each step.
  - [ ] Provide real-time feedback.
- [ ] **Core Verification Packages Implementation:**
  - [ ] Create/refine `verily_location` package.
  - [ ] Create/refine `verily_face_detection` package.
  - [ ] Create/refine `verily_device_motion` package.
  - [ ] Integrate packages into the Verily app's step execution logic.
- [ ] **Verification Reporting:**
  - [ ] Send step completion/final status updates to the backend.
- [ ] **Permissions Handling:**
  - [ ] Implement robust permission requests using `permission_handler`.

## Phase 4: Webhooks & Final Integration

- [ ] **Backend Webhook Dispatch:**
  - [ ] Implement logic to trigger webhooks based on verification status updates from the Verily app.
  - [ ] Implement signing mechanism for webhooks.
  - [ ] Implement basic retry logic.
- [ ] **`Reflexy` Demo App Update:**
  - [ ] Ensure `Reflexy` consumes the latest versions of `verily_*` packages/SDK.
  - [ ] Update `Reflexy` to showcase relevant verification types.
- [ ] **Testing:**
  - [ ] Write unit tests for backend logic.
  - [ ] Write unit/widget tests for Flutter apps/packages.
  - [ ] Perform manual E2E testing.

## Phase 5: Polish & Future Considerations

- [ ] Refine UI/UX based on `ui_requirements.md` (animations, styling).
- [ ] Implement chosen authentication methods fully.
- [ ] Add analytics features.
- [ ] Explore database migration to PostgreSQL.
- [ ] Documentation refinement.

---

_This task list is dynamic and subject to change as the project evolves._
