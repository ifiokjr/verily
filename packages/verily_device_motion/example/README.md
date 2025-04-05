# verily_device_motion Example

This Flutter application demonstrates how to use the `verily_device_motion` package.

## Functionality

The app utilizes the `MotionDetectorService` from the parent package to listen for specific device motion events:

- **Full Roll:** A complete 360-degree rotation around the phone's Y-axis (like doing a barrel roll).
- **Full Yaw:** A complete 360-degree rotation around the phone's Z-axis (like spinning in a circle flat on a table).
- **Drop:** A period of freefall followed by a significant impact.

It displays counters for each of these detected events, incrementing the respective counter each time an event occurs. The state management is handled using Flutter Riverpod.

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

The application should now launch, and you can try performing the roll, yaw, and drop motions to see the counters update.

## Demo Instructions

To test the functionality:

1. **Full Roll:** Hold your phone with the screen facing you and rotate it 360 degrees along its horizontal axis (like rolling a wheel).
2. **Full Yaw:** Place your phone flat on a table and rotate it 360 degrees (like a compass needle).
3. **Drop:** _Simulate_ a drop by rapidly moving the phone downward and then quickly stopping it. For safety, do not actually drop your device!

## Code Structure

This example uses a simplified implementation:

- `MotionCounts` - A simple class to hold the count values for each motion type.
- `MotionCounter` - A Riverpod Notifier that manages the state and interacts with the motion detection service.
- `MotionCounterScreen` - A Flutter UI to display the motion counters.

The app demonstrates how to:

- Initialize the `MotionDetectorService`
- Listen to motion events
- Update state based on detected events
- Properly dispose of resources when finished
