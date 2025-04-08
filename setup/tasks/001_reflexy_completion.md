# 001: Reflexy Game Core Completion

**Goal:** Develop a playable version of the `Reflexy` demo game by Wednesday morning, incorporating core action verification using device motion and Google ML Kit (Face, Pose/Hand detection). The focus is entirely on the frontend Flutter application.

**Timeline:** Due 2025-04-09 18:00

## Tasks

### 1. Project Setup & Package Structure

- [ ] **Define Package Structure:** Based on `specs/technical_requirements.md`, confirm the necessary packages to create for ML Kit features (e.g., `verily_face_detection`, `verily_pose_detection`).
- [ ] **Create `verily_face_detection` Package:**
  - Set up a new Flutter package at `/packages/verily_face_detection`.
  - Add `google_mlkit_face_detection` dependency.
  - Add necessary camera handling dependencies (or plan to use a shared `verily_camera` package if created).
  - Implement basic structure for face detection service/provider.
- [ ] **Create `verily_pose_detection` Package:**
  - Set up a new Flutter package at `/packages/verily_pose_detection`.
  - Add `google_mlkit_pose_detection` dependency.
  - Add necessary camera handling dependencies (or plan usage of `verily_camera`).
  - Implement basic structure for pose detection service/provider.
- [ ] **Add Package Dependencies to `Reflexy`:** Update `/apps/reflexy/pubspec.yaml` to include path dependencies for `verily_device_motion`, `verily_face_detection`, and `verily_pose_detection`.

### 2. UI/UX Implementation (`Reflexy` App)

- [ ] **Define Color Palette:**
  - Choose a clean, minimalist, Apple HIG-inspired color palette (primary, secondary, accent, background, text colors).
  - Document this briefly (e.g., in a `constants.dart` file or theme definition).
- [ ] **Implement Theme:** Set up the Flutter `ThemeData` in `Reflexy` using the defined color palette and appropriate typography (e.g., using `google_fonts` for SF Pro text or similar).
- [ ] **Create Basic Game Screen Layout:**
  - Design a simple layout showing the current action prompt (text/icon).
  - Include an area for camera preview (when needed for vision tasks).
  - Include areas for score/timer/feedback.
- [ ] **Implement Camera Preview Widget:** Create a reusable widget within `Reflexy` (or potentially `verily_camera` package) to display the camera feed, required for face/pose detection tasks.

### 3. Action Verification Implementation (Packages)

- [ ] **`verily_face_detection` - Implement Smile Detection:**
  - Integrate camera stream with `google_mlkit_face_detection`.
  - Process `Face` objects to check the `smilingProbability`.
  - Expose a function/stream like `Future<bool> verifySmile({Duration timeout})` or `Stream<bool> detectSmile()`.
- [ ] **`verily_face_detection` - Implement Blink Detection:**
  - Process `Face` objects, checking `leftEyeOpenProbability` and `rightEyeOpenProbability` over time to detect a blink.
  - Expose a function/stream like `Future<bool> verifyBlink({Duration timeout})`.
- [ ] **`verily_face_detection` - Implement Wink Detection:**
  - Process `Face` objects, checking `leftEyeOpenProbability` and `rightEyeOpenProbability` to detect a single eye closing.
  - Expose a function/stream like `Future<bool> verifyWink({Duration timeout})`.
- [ ] **`verily_pose_detection` - Implement Landmark Checks (Helper):**
  - Create helper functions to check the position/visibility of specific `PoseLandmark` types (e.g., Nose, Left/Right Cheek, Forehead, Left/Right Hand, Left/Right Thumb).
- [ ] **`verily_pose_detection` - Implement Thumbs Up/Down:**
  - Integrate camera stream with `google_mlkit_pose_detection`.
  - Analyze hand landmarks (specifically thumb position relative to other hand landmarks) to detect thumbs up/down.
  - Expose functions like `Future<bool> verifyThumbsUp({Duration timeout})`, `Future<bool> verifyThumbsDown({Duration timeout})`.
- [ ] **`verily_pose_detection` - Implement Touch Cheek/Nose/Forehead:**
  - Analyze pose landmarks to determine proximity between hand landmarks (e.g., index finger tip) and facial landmarks (e.g., nose, cheek, forehead center - might need approximation).
  - Expose functions like `Future<bool> verifyTouchNose({Duration timeout})`, etc.
- [ ] **`verily_pose_detection` - Implement Pat Head:**
  - Analyze pose landmarks to detect hand landmark(s) above and potentially making contact with head landmarks (might require tracking motion/velocity).
  - Expose function like `Future<bool> verifyPatHead({Duration timeout})`.
- [ ] **Refine `verily_device_motion` (If Needed):** Ensure existing motion detection actions (tilt, shake etc.) are clearly exposed and functional.

### 4. Game Logic (`Reflexy` App)

- [ ] **Define Action List:** Create an enum or list of all possible actions (`TiltLeft`, `Smile`, `ThumbsUp`, `TouchNose`, etc.).
- [ ] **Implement Game State Management (Riverpod):**
  - Manage current score, timer, current action, game state (playing, game over).
- [ ] **Implement Action Sequencer:** Logic to randomly select the next action prompt for the user.
- [ ] **Integrate Verification Calls:** Based on the current action prompt, call the appropriate verification function from the corresponding package (`verily_device_motion`, `verily_face_detection`, `verily_pose_detection`).
- [ ] **Handle Permissions:** Use `permission_handler` to request camera and motion sensor permissions before starting relevant actions.
- [ ] **Update UI Based on State:** Connect the UI to the game state (show correct prompt, update score/timer, provide feedback on success/failure).
- [ ] **Implement Basic Scoring/Timer:** Simple timer countdown for each action and score increment on success.

### 5. Testing & Refinement

- [ ] **Manual Testing:** Thoroughly test each action on a physical device (iOS and Android if possible).
- [ ] **Debug ML Accuracy:** Tweak probabilities/thresholds/logic in detection functions for reasonable accuracy.
- [ ] **Performance Check:** Ensure camera feed and ML processing don't cause significant lag or battery drain.
- [ ] **Code Cleanup:** Basic cleanup and formatting.
