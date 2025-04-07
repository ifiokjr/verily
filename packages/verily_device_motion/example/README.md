# verily_device_motion Example

This Flutter application demonstrates how to use the `verily_device_motion` package with Flutter Hooks and Riverpod for state management, including interactive sensitivity controls.

## Functionality

The app utilizes the `MotionDetectorService` from the parent package to listen for specific device motion events:

- **Yaw Rotation:** Rotation around the phone's Z-axis (like spinning flat). Threshold configurable via slider (default 270°).
- **Roll Rotation:** Rotation around the phone's Y-axis (like a barrel roll). Threshold configurable via slider (default 270°).
- **Drop:** A period of freefall followed by impact. Sensitivity configurable via slider (default 1.0).

It displays counters for drop events, and separate counters for Clockwise (CW) and Counter-Clockwise (CCW) directions for yaw and roll events.

## State Management & Hooks

This example demonstrates several Flutter development patterns:

- **Flutter Hooks**: For handling stateful logic (sensitivity slider values) and widget lifecycle.
- **Hooks Riverpod**: For global state management (event counts).
- **Custom Hooks**: `useMotionDetector` hook encapsulates the service setup (passing sensitivities) and cleanup.

## Running the Example

1. **Navigate to the example directory:**
   ```bash
   cd packages/verily_device_motion/example
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:** Connect a device or start an emulator/simulator.
   ```bash
   flutter run
   ```

The application should now launch. You can adjust the sensitivity sliders and perform the motions to see the counters update.

## Demo Instructions

To test the functionality:

1. **Yaw (Spin):** Place your phone flat and rotate it. Observe the CW/CCW counters. Adjust the Yaw Sensitivity slider to change the required rotation angle (e.g., 0.5 requires 180°).
2. **Roll (Barrel):** Hold your phone screen-up and rotate it along its horizontal axis. Observe the CW/CCW counters. Adjust the Roll Sensitivity slider.
3. **Drop:** _Simulate_ a drop by moving the phone down quickly and stopping abruptly. Adjust the Drop Sensitivity slider (higher values make it easier to trigger).

## Code Structure

The example demonstrates using hooks with Riverpod:

- **Custom Hook (`useMotionDetector`)**: Manages the setup, lifecycle (reacting to sensitivity changes), and disposal of the motion detector.
- **State Hook (`useState`)**: Used within the UI to manage the current values of the sensitivity sliders.
- **State Provider (`motionCountsProvider`)**: A Riverpod StateProvider holding the directional event counts.
- **HookConsumerWidget**: Combines Flutter Hooks with Riverpod's Consumer functionality.
- **useEffect**: Manages side effects like stream subscriptions.
- **useCallback**: Memoizes the reset function.

This architecture demonstrates how to:

- Use hooks to encapsulate stateful logic and manage local UI state (sliders).
- Create custom hooks for reusable functionality, reacting to input changes.
- Combine hooks with Riverpod for comprehensive state management.
- Handle lifecycle events and resource cleanup.
- Subscribe to streams and update state based on events and their direction.
- Configure the `MotionDetectorService` with dynamic parameters.
