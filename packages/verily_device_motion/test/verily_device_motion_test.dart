import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
       final service = MotionDetectorService(
         freefallTimeThreshold: const Duration(milliseconds: 50),
         impactDetectionWindow: const Duration(milliseconds: 100),
         detectionResetDelay: const Duration(milliseconds: 200),
         freefallThreshold: 1.5,
         impactThreshold: 20.0,
       );

       expectLater(
           service.motionEvents,
           emits(isA<MotionEvent>()
               .having((e) => e!.type, 'type', MotionEventType.drop)
               .having((e) => e!.value, 'value', isNotNull)));

       service.startListening();
       await Future.delayed(Duration.zero); // Allow listener setup

       // 1. Simulate freefall (low acceleration)
       simulateSensorEvent(eventChannelAccelerometer, [0.5, 0.5, 0.5]);
       await Future.delayed(const Duration(milliseconds: 60)); // > freefall threshold

       // 2. Simulate end of freefall (normal gravity)
       simulateSensorEvent(eventChannelAccelerometer, [0.0, 9.8, 0.0]);
       await Future.delayed(Duration.zero); // Allow impact check to potentially start

       // 3. Simulate impact (high acceleration) within the window
       // Note: The service internally uses fastestInterval for impact check,
       // but our mock sends to the same event channel regardless.
       simulateSensorEvent(eventChannelAccelerometer, [5.0, -25.0, 3.0]);

       await Future.delayed(const Duration(milliseconds: 250)); // Wait past detection reset delay

       service.dispose();
     });

    test('does not detect drop if impact is outside window', () async {
       final service = MotionDetectorService(
         freefallTimeThreshold: const Duration(milliseconds: 50),
         impactDetectionWindow: const Duration(milliseconds: 100),
         detectionResetDelay: const Duration(milliseconds: 200),
         freefallThreshold: 1.5,
         impactThreshold: 20.0,
       );

       expectLater(service.motionEvents, emitsDone);

       service.startListening();
       await Future.delayed(Duration.zero); // Allow listener setup

       // 1. Simulate freefall
       simulateSensorEvent(eventChannelAccelerometer, [0.5, 0.5, 0.5]);
       await Future.delayed(const Duration(milliseconds: 60)); // > freefall threshold

       // 2. Simulate end of freefall
       simulateSensorEvent(eventChannelAccelerometer, [0.0, 9.8, 0.0]);

       // 3. Wait LONGER than the impact detection window
       await Future.delayed(const Duration(milliseconds: 150));

       // 4. Simulate impact (now it's too late)
       simulateSensorEvent(eventChannelAccelerometer, [5.0, -25.0, 3.0]);

       await Future.delayed(const Duration(milliseconds: 50)); // Wait a bit more

       service.dispose(); // Closes the stream, fulfilling emitsDone
     });

     // TODO: Add tests for MotionEventType.fullYaw (using eventChannelGyroscope)
     // TODO: Add tests for MotionEventType.fullRoll (using eventChannelGyroscope)

  });
}
