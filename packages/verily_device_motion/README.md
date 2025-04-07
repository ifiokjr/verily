<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# verily_device_motion

A Flutter package for detecting specific device motion events like drops, yaw rotations, and roll rotations using accelerometer and gyroscope data.

## Features

- Detects device drops based on freefall followed by impact.
- Detects yaw rotations (spinning flat) based on a configurable angle threshold.
- Detects roll rotations (barrel roll) based on a configurable angle threshold.
- Provides the direction (Clockwise/Counter-Clockwise) for rotation events.
- Provides a simple stream-based API (`motionEvents`).
- Configurable sensitivity for drop, yaw, and roll detection.

## Getting Started

1. **Add Dependency:** Add `verily_device_motion` to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     verily_device_motion:
       # Replace with the actual path or pub version
       path: ../packages/verily_device_motion
     sensors_plus: ^6.0.0 # Ensure this matches or is compatible
   ```

2. **Import:**
   ```dart
   import 'package:verily_device_motion/verily_device_motion.dart';
   ```

## Usage

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MotionDetectorService _motionDetectorService;
  StreamSubscription<MotionEvent>? _motionSubscription;
  String _lastEvent = 'None';

  @override
  void initState() {
    super.initState();
    // Initialize the service (optionally configure parameters)
    _motionDetectorService = MotionDetectorService(
      // Example: Make drop detection twice as sensitive
      dropSensitivity: 2.0,
      // Example: Trigger yaw/roll after 180 degrees (0.5 sensitivity)
      yawSensitivity: 0.5,
      rollSensitivity: 0.5,
      // Other parameters like freefallTimeThreshold, detectionResetDelay etc.
      // can also be customized here.
    );
    _motionDetectorService.startListening();

    // Listen to the motion events stream
    _motionSubscription = _motionDetectorService.motionEvents.listen((event) {
      setState(() {
        String directionInfo = '';
        if (event.type == MotionEventType.yaw || event.type == MotionEventType.roll) {
           directionInfo = ' Direction: ${event.direction?.name}';
        }
        _lastEvent = '${event.type.name} at ${event.timestamp.toIso8601String()}$directionInfo';
        if (event.type == MotionEventType.drop) {
          _lastEvent += ' (Impact: ${event.value?.toStringAsFixed(2)} m/s²)';
        }
        print("Motion Detected: $_lastEvent");
      });
    });
  }

  @override
  void dispose() {
    _motionSubscription?.cancel();
    _motionDetectorService.dispose(); // IMPORTANT: Dispose the service
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Motion Detector Demo'),
        ),
        body: Center(
          child: Text('Last Motion Event: $_lastEvent'),
        ),
      ),
    );
  }
}
```

## Configuration

The `MotionDetectorService` constructor accepts several parameters to fine-tune detection:

- `freefallThreshold` (double, default: 1.5): Acceleration magnitude (m/s²) below which freefall is considered.
- `freefallTimeThreshold` (Duration, default: 150ms): Minimum freefall duration required.
- `dropSensitivity` (double, default: 1.0): Adjusts the impact force needed for drop detection. Values > 1 increase sensitivity (easier to trigger), < 1 decrease sensitivity (harder to trigger). Must be > 0.
- `yawSensitivity` (double, default: 0.75): Fraction of 360 degrees required for a yaw event (0.0 < sensitivity <= 1.0). 0.75 means 270 degrees.
- `rollSensitivity` (double, default: 0.75): Fraction of 360 degrees required for a roll event (0.0 < sensitivity <= 1.0). 0.75 means 270 degrees.
- `impactDetectionWindow` (Duration, default: 500ms): Time window after freefall to check for impact.
- `rotationRateStopThreshold` (double, default: 0.1): Rotation rate (rad/s) below which accumulated rotation resets.
- `detectionResetDelay` (Duration, default: 3s): Cooldown period after an event of the same type.

## Example App

See the `example/` directory for a runnable Flutter application demonstrating the package usage with Flutter Hooks, Riverpod, and interactive sensitivity sliders.

## Additional information

TODO: Tell users more about the package: where to find more information, how to contribute to the package, how to file issues, what response they can expect from the package authors, and more.
