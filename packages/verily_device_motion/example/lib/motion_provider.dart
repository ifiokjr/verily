import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
// Use the main library export instead of the specific service file
import 'package:verily_device_motion/verily_device_motion.dart';

import 'motion_counts.dart';

part 'motion_provider.g.dart';

@riverpod
class MotionCounter extends _$MotionCounter {
  // Keep a single subscription to the main event stream
  StreamSubscription<MotionEvent>? _motionSubscription;
  // Hold the instance of the service
  late MotionDetectorService _motionDetectorService;

  @override
  MotionCounts build() {
    // Instantiate the service
    _motionDetectorService = MotionDetectorService();
    // Start listening to sensor events
    _motionDetectorService.startListening();

    // Listen to the single motion event stream
    _motionSubscription = _motionDetectorService.motionEvents.listen(
      (event) {
        // Update state based on the type of motion event received
        switch (event.type) {
          case MotionEventType.fullRoll:
            state = state.copyWith(rollCount: state.rollCount + 1);
            break;
          case MotionEventType.fullYaw:
            state = state.copyWith(yawCount: state.yawCount + 1);
            break;
          case MotionEventType.drop:
            state = state.copyWith(dropCount: state.dropCount + 1);
            break;
        }
      },
      onError: (error) {
        // Optional: Handle stream errors
        print("Motion Event Stream Error: $error");
      },
    );

    // Ensure resources are cleaned up when the provider is disposed
    ref.onDispose(() {
      print("Disposing MotionCounter provider and service..."); // Debug log
      _motionSubscription?.cancel();
      _motionDetectorService.dispose(); // Call dispose on the service instance
    });

    // Return the initial state
    return const MotionCounts();
  }

  // Optional: Method to reset counts if needed
  void resetCounts() {
    state = const MotionCounts();
  }
}
