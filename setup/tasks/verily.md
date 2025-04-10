# Verily Project Tasks - Action Verification Platform

**Date Created:** 2024-07-27

**AI Assistant Note:** Remember to check off tasks here as they are completed. Update this list frequently to reflect the current project state.

## Phase 1: Foundation & Backend Setup (Deno/tRPC)

- [ ] **Project Structure:**
  - [ ] Create/Verify initial monorepo directory structure (`/apps`, `/packages`, `/backend`, `/setup`, etc.).
  - [ ] Initialize `fvm` for Flutter version management.
  - [ ] Initialize Deno project in `/backend` (e.g., create `deno.jsonc`).
- [ ] **Backend Dependencies:**
  - [ ] Add core Deno/tRPC dependencies (`@trpc/server`, `@trpc/client`, `zod`, `@std/path`, etc.) to `deno.jsonc`.
- [ ] **tRPC Backend Setup:**
  - [ ] Set up basic tRPC server structure (`/backend/server/trpc.ts`, `/backend/server/index.ts`).
  - [ ] Define initial `AppRouter` (`/backend/server/router.ts` or within `index.ts`).
  - [ ] Implement context creation (`/backend/server/context.ts`).
  - [ ] Set up data storage layer (initial file-based JSON - `/backend/server/db.ts`, `/backend/data/data.json`).
  - [ ] Implement basic health check or root procedure.
- [ ] **Database Schema Definition (Conceptual for initial JSON, Formal for later DB):**
  - [ ] Define structure for `Actions` data.
  - [ ] Define structure for `ActionSteps` data.
  - [ ] Define structure for `Creators` data.
  - [ ] Define structure for `Webhooks` data.
  - [ ] Define structure for `VerificationAttempts` data.
  - [ ] *Task:* Update `/migrations` if/when migrating to SQL database later.
- [ ] **Core Backend API (`Verily Create` related tRPC procedures):**
  - [ ] Implement procedures (queries/mutations) for CRUD operations on `Actions`.
  - [ ] Implement procedures for CRUD operations on `ActionSteps`.
  - [ ] Implement procedures for CRUD operations on `Webhooks`.
  - [ ] Implement basic authentication middleware for creator-specific procedures.
- [ ] **Flutter tRPC Client Setup (`packages/verily_trpc`):**
  - [ ] Add `trpc-client-dart` dependencies (`trpc_client`, `freezed_annotation`, `json_annotation`).
  - [ ] Add build dependencies (`build_runner`, `freezed`, `json_serializable`, `trpc_client_generator`).
  - [ ] Configure `build.yaml` (if necessary) for the generator.
  - [ ] Create the initial client definition file pointing to the backend router type definition.
  - [ ] Run `build_runner` to generate initial client code.
- [ ] **Remove Old Backend Code:**
  - [ ] Delete any existing Rust code/files within the `/backend` directory.
  - [ ] Search codebase for "Rust", "Axum", "SQLX", "Tokio", "Serde", "Cargo" and remove references.

## Phase 2: `Verily Create` Application (Web)

- [ ] **Flutter Web Setup:**
  - [ ] Initialize/Verify Flutter web project in `/apps/verily_create`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation/routing.
- [ ] **Creator Authentication UI:**
  - [ ] Implement basic login/signup UI.
- [ ] **Action Management UI:**
  - [ ] List existing actions.
  - [ ] Form to create/edit actions (name, description).
  - [ ] Interface to add/edit/reorder action steps (selecting type, configuring parameters).
  - [ ] Interface to manage webhooks for actions.
  - [ ] Display generated Action URL/QR code.
- [ ] **tRPC Integration:**
  - [ ] Integrate the generated `verily_trpc` client.
  - [ ] Connect UI components to backend tRPC procedures.

## Phase 3: `Verily` Application (Mobile)

- [ ] **Flutter Mobile Setup:**
  - [ ] Initialize/Verify Flutter mobile project in `/apps/verily`.
  - [ ] Configure Riverpod state management.
  - [ ] Set up basic navigation.
- [ ] **Action Initiation:**
  - [ ] Implement QR code scanner.
  - [ ] Implement deep link handling.
  - [ ] Fetch action details via tRPC procedure using URL/ID.
- [ ] **Action Execution Flow:**
  - [ ] Display action instructions/steps.
  - [ ] Implement UI for guiding user through each step.
  - [ ] Provide real-time feedback.
- [ ] **Core Verification Packages Implementation:**
  - [ ] Create/refine/verify `verily_location` package.
  - [ ] Create/refine/verify `verily_face_detection` package.
  - [ ] Create/refine/verify `verily_device_motion` package.
  - [ ] Integrate packages into the Verily app's step execution logic.
- [ ] **Verification Reporting (via tRPC):**
  - [ ] Call tRPC mutations to send step completion/final status updates to the backend.
- [ ] **Permissions Handling:**
  - [ ] Implement robust permission requests using `permission_handler`.

## Phase 4: Webhooks & Final Integration

- [ ] **Backend Webhook Dispatch Logic:**
  - [ ] Implement logic within tRPC procedures (or separate functions called by them) to trigger webhooks based on verification status updates.
  - [ ] Implement signing mechanism for webhooks.
  - [ ] Implement basic retry logic.
- [ ] **`Reflexy` Demo App Update:**
  - [ ] Ensure `Reflexy` consumes the latest versions of `verily_*` packages.
  - [ ] Update `Reflexy` to showcase relevant verification types.
- [ ] **Testing:**
  - [ ] Write unit tests for backend tRPC procedures/logic (Deno).
  - [ ] Write unit/widget tests for Flutter apps/packages.
  - [ ] Perform manual E2E testing.

## Phase 5: Polish & Future Considerations

- [ ] Refine UI/UX based on `ui_requirements.md` (animations, styling).
- [ ] Implement chosen authentication methods fully.
- [ ] Add analytics features.
- [ ] Plan and execute migration from JSON storage to a database (SQLite/PostgreSQL).
- [ ] Documentation refinement.

---

_This task list is dynamic and subject to change as the project evolves._
