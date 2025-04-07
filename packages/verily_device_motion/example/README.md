# verily_device_motion Example

This Flutter application demonstrates how to use the `verily_device_motion` package with Flutter Hooks and Riverpod for state management.

## Functionality

The app utilizes the `MotionDetectorService` from the parent package to listen for specific device motion events:

- **Full Roll:** A complete 360-degree rotation around the phone's Y-axis (like doing a barrel roll).
- **Full Yaw:** A complete 360-degree rotation around the phone's Z-axis (like spinning in a circle flat on a table).
- **Drop:** A period of freefall followed by a significant impact. This example configures the drop detection to be 50% more sensitive than the default (`dropSensitivity: 1.5`).

It displays counters for each of these detected events, incrementing the respective counter each time an event occurs.

## State Management & Hooks

This example demonstrates several Flutter development patterns:

- **Flutter Hooks**: For handling stateful logic and widget lifecycle
- **Hooks Riverpod**: For global state management
- **Custom Hooks**: We create a custom `useMotionDetector` hook that encapsulates the motion detector setup (including setting `dropSensitivity`) and cleanup

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

The application should now launch, and you can try performing the roll, yaw, and drop motions to see the counters update. Note that drops might trigger more easily due to the increased sensitivity setting.

## Demo Instructions

To test the functionality:

1. **Full Roll:** Hold your phone with the screen facing you and rotate it 360 degrees along its horizontal axis (like rolling a wheel).
2. **Full Yaw:** Place your phone flat on a table and rotate it 360 degrees (like a compass needle).
3. **Drop:** _Simulate_ a drop by rapidly moving the phone downward and then quickly stopping it. For safety, do not actually drop your device! Remember this example has increased drop sensitivity.

## Code Structure

The example demonstrates using hooks with Riverpod:

- **Custom Hook (`useMotionDetector`)**: Manages the setup, lifecycle, and disposal of the motion detector, including passing the `dropSensitivity`
- **State Provider (`motionCountsProvider`)**: A simple Riverpod StateProvider that holds the counter values
- **HookConsumerWidget**: Combines Flutter Hooks with Riverpod's Consumer functionality
- **useEffect**: Manages side effects like stream subscriptions
- **useCallback**: Memoizes functions to prevent unnecessary rebuilds

This architecture demonstrates how to:

- Use hooks to encapsulate stateful logic
- Create custom hooks for reusable functionality
- Combine hooks with Riverpod for comprehensive state management
- Handle lifecycle events and resource cleanup
- Subscribe to streams and update state based on events
- Configure the `MotionDetectorService` with parameters like `dropSensitivity`
