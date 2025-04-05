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

3. **Run code generation:** This step is necessary to generate files required by Riverpod Generator and Freezed.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   _(If you encounter issues, you might need to run `flutter clean` in this directory first)_

4. **Run the application:** Connect a device or start an emulator/simulator.
   ```bash
   flutter run
   ```

The application should now launch, and you can try performing the roll, yaw, and drop motions to see the counters update.
