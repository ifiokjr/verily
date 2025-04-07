import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_device_motion/src/motion_detector_service.dart';

// Helper to encode sensor data
ByteData _encodeSensorData(List<double> values) {
  final Float64List list = Float64List.fromList(values);
  return list.buffer.asByteData();
}

// Note: We removed the MessageHandler typedef as it's no longer needed with this approach

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Channel names (match sensors_plus implementation)
  const methodChannelAccelerometer = 'dev.fluttercommunity.plus/sensors/accelerometer';
  const eventChannelAccelerometer = 'dev.fluttercommunity.plus/sensors/accelerometer_event';
  const methodChannelGyroscope = 'dev.fluttercommunity.plus/sensors/gyroscope';
  const eventChannelGyroscope = 'dev.fluttercommunity.plus/sensors/gyroscope_event';

  // Helper to mock MethodChannel calls (listen/cancel)
  void setMockMethodCallHandler(String channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel(channelName), (MethodCall methodCall) async {
      if (methodCall.method == 'listen') {
        // Simulate successful listen call
        return null;
      } else if (methodCall.method == 'cancel') {
        // Simulate successful cancel call & clear the event channel handler
         TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(channelName.replaceFirst('_event', ''), null); // Assumes event channel name derivation
        return null;
      }
      return null;
    });
  }

  // Helper to simulate events coming from the platform on the EventChannel
   void simulateSensorEvent(String eventChannelName, List<double> data) {
      final byteData = _encodeSensorData(data);
      // Use handlePlatformMessage to simulate the platform sending data *on the event channel*
      // The framework routes this to the listener set up by the service.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(eventChannelName, byteData, (ByteData? reply) {
              // Callback for the platform side (not used here)
          });
   }


  setUp(() {
    // Mock the method channels for listen/cancel
    setMockMethodCallHandler(methodChannelAccelerometer);
    setMockMethodCallHandler(methodChannelGyroscope);

    // Set default null handlers for event channels (will be overridden by service's listener)
    // This isn't strictly necessary but good practice.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannelAccelerometer, (message) async => null);
     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannelGyroscope, (message) async => null);

  });

  tearDown(() {
    // Clear all handlers
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel(methodChannelAccelerometer), null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel(methodChannelGyroscope), null);
     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannelAccelerometer, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannelGyroscope, null);
  });

  group('MotionDetectorService', () {
    test('can be initialized and disposed', () async {
      expect(() async {
        final service = MotionDetectorService();
        service.startListening();
        // Allow time for listen calls to complete
        await Future.delayed(Duration.zero);
        // No direct way to check listener setup with this mock, rely on absence of errors
        service.dispose();
        // No direct way to check listener teardown, rely on absence of errors
      }, returnsNormally);
    });

    test('exposes a motionEvents stream', () {
      final service = MotionDetectorService();
      expect(service.motionEvents, isA<Stream<MotionEvent>>());
      service.dispose();
    });

    test('detects drop after freefall and impact', () async {
       // Base threshold is 25.0. Sensitivity 1.25 -> effective threshold 25.0 / 1.25 = 20.0
       final service = MotionDetectorService(
         dropSensitivity: 1.25,
         freefallTimeThreshold: const Duration(milliseconds: 50),
         impactDetectionWindow: const Duration(milliseconds: 100),
         detectionResetDelay: const Duration(milliseconds: 200),
         freefallThreshold: 1.5,
       );
       const double effectiveImpactThreshold = 25.0 / 1.25; // 20.0

       expectLater(
           service.motionEvents,
           emits(isA<MotionEvent>()
               .having((e) => e.type, 'type', MotionEventType.drop)
               .having((e) => e.value, 'value', greaterThan(effectiveImpactThreshold))));

       service.startListening();
       await Future.delayed(Duration.zero); // Allow listener setup

       // 1. Simulate freefall (low acceleration)
       simulateSensorEvent(eventChannelAccelerometer, [0.5, 0.5, 0.5]);
       await Future.delayed(const Duration(milliseconds: 60)); // > freefall time threshold

       // 2. Simulate end of freefall (normal gravity)
       simulateSensorEvent(eventChannelAccelerometer, [0.0, 9.8, 0.0]);
       await Future.delayed(Duration.zero); // Allow impact check to potentially start

       // 3. Simulate impact > effective threshold
       simulateSensorEvent(eventChannelAccelerometer, [5.0, -25.0, 3.0]); // Magnitude ~25.8 > 20.0

       await Future.delayed(const Duration(milliseconds: 250)); // Wait past detection reset delay

       service.dispose();
     });

    test('does not detect drop if impact is below effective threshold', () async {
       // Base threshold is 25.0. Sensitivity 0.8 -> effective threshold 25.0 / 0.8 = 31.25
       final service = MotionDetectorService(
         dropSensitivity: 0.8,
         freefallTimeThreshold: const Duration(milliseconds: 50),
         impactDetectionWindow: const Duration(milliseconds: 100),
         detectionResetDelay: const Duration(milliseconds: 200),
         freefallThreshold: 1.5,
       );

       expectLater(service.motionEvents, emitsDone);

       service.startListening();
       await Future.delayed(Duration.zero); // Allow listener setup

        // 1. Simulate freefall
       simulateSensorEvent(eventChannelAccelerometer, [0.5, 0.5, 0.5]);
       await Future.delayed(const Duration(milliseconds: 60));

       // 2. Simulate end of freefall
       simulateSensorEvent(eventChannelAccelerometer, [0.0, 9.8, 0.0]);
       await Future.delayed(Duration.zero);

       // 3. Simulate impact BELOW effective threshold
       simulateSensorEvent(eventChannelAccelerometer, [5.0, -25.0, 3.0]); // Magnitude ~25.8 < 31.25

       await Future.delayed(const Duration(milliseconds: 50));
       service.dispose(); // Closes the stream, fulfilling emitsDone
    });

    test('detects yaw clockwise rotation', () async {
      final service = MotionDetectorService(
        yawSensitivity: 0.5, // 180 degrees
        detectionResetDelay: const Duration(milliseconds: 100),
      );
      final double effectiveThreshold = math.pi; // 0.5 * 2 * pi

      expectLater(
          service.motionEvents,
          emits(isA<MotionEvent>()
              .having((e) => e.type, 'type', MotionEventType.yaw)
              .having((e) => e.direction, 'direction', RotationDirection.clockwise)));

      service.startListening();
      await Future.delayed(Duration.zero);

      // Simulate clockwise rotation (positive Z rate)
      // Rotate slightly more than 180 degrees in 1 second
      final double rate = effectiveThreshold * 1.1; // rad/s
      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, rate]); // x, y, z
      await Future.delayed(const Duration(seconds: 1));

      // Stop rotation to ensure event isn't missed due to threshold check timing
      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, 0.0]);
      await Future.delayed(const Duration(milliseconds: 150)); // Wait past reset delay

      service.dispose();
    });

     test('detects yaw counter-clockwise rotation', () async {
      final service = MotionDetectorService(
        yawSensitivity: 0.75, // 270 degrees
        detectionResetDelay: const Duration(milliseconds: 100),
      );
      final double effectiveThreshold = 1.5 * math.pi; // 0.75 * 2 * pi

      expectLater(
          service.motionEvents,
          emits(isA<MotionEvent>()
              .having((e) => e.type, 'type', MotionEventType.yaw)
              .having((e) => e.direction, 'direction', RotationDirection.counterClockwise)));

      service.startListening();
      await Future.delayed(Duration.zero);

      // Simulate counter-clockwise rotation (negative Z rate)
      final double rate = -effectiveThreshold * 1.1; // rad/s
      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, rate]); // x, y, z
      await Future.delayed(const Duration(seconds: 1));

      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, 0.0]);
      await Future.delayed(const Duration(milliseconds: 150));

      service.dispose();
    });

    test('detects roll clockwise rotation', () async {
      final service = MotionDetectorService(
        rollSensitivity: 0.6, // 216 degrees
        detectionResetDelay: const Duration(milliseconds: 100),
      );
      final double effectiveThreshold = 1.2 * math.pi; // 0.6 * 2 * pi

      expectLater(
          service.motionEvents,
          emits(isA<MotionEvent>()
              .having((e) => e.type, 'type', MotionEventType.roll)
              .having((e) => e.direction, 'direction', RotationDirection.clockwise)));

      service.startListening();
      await Future.delayed(Duration.zero);

      // Simulate clockwise roll (positive Y rate)
      final double rate = effectiveThreshold * 1.1; // rad/s
      simulateSensorEvent(eventChannelGyroscope, [0.0, rate, 0.0]); // x, y, z
      await Future.delayed(const Duration(seconds: 1));

      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, 0.0]);
      await Future.delayed(const Duration(milliseconds: 150));

      service.dispose();
    });

     test('detects roll counter-clockwise rotation', () async {
      final service = MotionDetectorService(
        rollSensitivity: 0.9, // 324 degrees
        detectionResetDelay: const Duration(milliseconds: 100),
      );
      final double effectiveThreshold = 1.8 * math.pi; // 0.9 * 2 * pi

      expectLater(
          service.motionEvents,
          emits(isA<MotionEvent>()
              .having((e) => e.type, 'type', MotionEventType.roll)
              .having((e) => e.direction, 'direction', RotationDirection.counterClockwise)));

      service.startListening();
      await Future.delayed(Duration.zero);

      // Simulate counter-clockwise roll (negative Y rate)
      final double rate = -effectiveThreshold * 1.1; // rad/s
      simulateSensorEvent(eventChannelGyroscope, [0.0, rate, 0.0]); // x, y, z
      await Future.delayed(const Duration(seconds: 1));

      simulateSensorEvent(eventChannelGyroscope, [0.0, 0.0, 0.0]);
      await Future.delayed(const Duration(milliseconds: 150));

      service.dispose();
    });

  });
}
