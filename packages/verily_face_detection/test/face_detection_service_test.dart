import 'dart:math' show Point;
import 'dart:ui' show Rect; // Import Rect
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:verily_face_detection/verily_face_detection.dart';

import 'face_detection_service_test.mocks.dart';

// REMOVED manual mock class, build_runner will generate MockCameraImage
// class MockCameraImage extends Mock implements CameraImage {}

// Helper to create a mock Face
Face _createMockFace({
  double? smilingProbability,
  double? leftEyeOpenProbability,
  double? rightEyeOpenProbability,
  Map<FaceLandmarkType, FaceLandmark> landmarks = const {},
}) {
  final face = MockFace();
  when(face.smilingProbability).thenReturn(smilingProbability);
  when(face.leftEyeOpenProbability).thenReturn(leftEyeOpenProbability);
  when(face.rightEyeOpenProbability).thenReturn(rightEyeOpenProbability);
  when(face.landmarks).thenReturn(landmarks);
  when(face.boundingBox).thenReturn(Rect.zero); // Mock bounding box
  when(face.headEulerAngleX).thenReturn(0.0);
  when(face.headEulerAngleY).thenReturn(0.0);
  when(face.headEulerAngleZ).thenReturn(0.0);
  when(face.trackingId).thenReturn(null);
  when(face.contours).thenReturn({});
  return face;
}

// Helper to create a FaceLandmark
FaceLandmark _createLandmark(int x, int y) {
  final landmark = MockFaceLandmark();
  when(landmark.position).thenReturn(Point(x, y));
  return landmark;
}

@GenerateMocks([
  FaceDetector,
  Face,
  FaceLandmark,
  CameraImage,
  Plane,
  ImageFormat // Add ImageFormat to mocks
])
void main() {
  group('FaceDetectionService', () {
    late MockFaceDetector mockDetector;
    late FaceDetectionService service;
    late MockCameraImage mockCameraImage;
    const mockRotation = InputImageRotation.rotation0deg;

    setUp(() {
      mockDetector = MockFaceDetector();
      service = FaceDetectionService(detector: mockDetector);
      mockCameraImage = MockCameraImage();

      // Mock CameraImage properties needed for conversion
      final mockFormat = MockImageFormat(); // Create mock ImageFormat
      when(mockFormat.group).thenReturn(ImageFormatGroup.nv21);
      // Mock raw value as it seems to be accessed by the conversion logic now
      when(mockFormat.raw).thenReturn(17); // Using Android's NV21 value as placeholder

      when(mockCameraImage.format).thenReturn(mockFormat);
      when(mockCameraImage.width).thenReturn(640);
      when(mockCameraImage.height).thenReturn(480);

      // Mock Plane
      final mockPlane = MockPlane();
      when(mockPlane.bytesPerRow).thenReturn(640);
      when(mockPlane.height).thenReturn(480);
      when(mockPlane.width).thenReturn(640);
      // Ensure bytes list size matches expected NV21 format (Y plane + UV plane)
      when(mockPlane.bytes).thenReturn(Uint8List(640 * 480 * 3 ~/ 2));

      when(mockCameraImage.planes).thenReturn([mockPlane]);
    });

    tearDown(() {
      service.dispose();
    });

    test(
        'processImage should emit smile gesture when smilingProbability is high', () async {
      final smilingFace = _createMockFace(smilingProbability: 0.9);
      when(mockDetector.processImage(any))
          .thenAnswer((_) async => [smilingFace]);

      // Expect a list containing one smile gesture
      expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          return gestures.length == 1 &&
                 gestures.first.type == GestureType.smile &&
                 gestures.first.confidence == 0.9;
        })),
      );

      await service.processImage(mockCameraImage, mockRotation);
    });

    test(
        'processImage should emit blink gesture when both eyes are closed', () async {
      final blinkingFace =
          _createMockFace(leftEyeOpenProbability: 0.05, rightEyeOpenProbability: 0.05);
      when(mockDetector.processImage(any))
          .thenAnswer((_) async => [blinkingFace]);

      expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          if (gestures.length != 1) return false;
          final gesture = gestures.first;
          final expectedConfidence = 0.95;
          final epsilon = 0.01;
          return gesture.type == GestureType.blink &&
                 (gesture.confidence - expectedConfidence).abs() < epsilon;
        })),
      );

      await service.processImage(mockCameraImage, mockRotation);
    });

    test(
        'processImage should emit wink gesture when only left eye is closed', () async {
       final winkingFace =
          _createMockFace(leftEyeOpenProbability: 0.05, rightEyeOpenProbability: 0.9);
      when(mockDetector.processImage(any))
          .thenAnswer((_) async => [winkingFace]);

       expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          if (gestures.length != 1) return false;
          final gesture = gestures.first;
          final expectedConfidence = 0.95; // 1 - 0.05
          final epsilon = 0.01;
          return gesture.type == GestureType.wink &&
                 (gesture.confidence - expectedConfidence).abs() < epsilon;
        })),
      );

      await service.processImage(mockCameraImage, mockRotation);
    });

     test(
        'processImage should emit wink gesture when only right eye is closed', () async {
       final winkingFace =
          _createMockFace(leftEyeOpenProbability: 0.9, rightEyeOpenProbability: 0.05);
      when(mockDetector.processImage(any))
          .thenAnswer((_) async => [winkingFace]);

       expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          if (gestures.length != 1) return false;
          final gesture = gestures.first;
          final expectedConfidence = 0.95; // 1 - 0.05
          final epsilon = 0.01;
          return gesture.type == GestureType.wink &&
                 (gesture.confidence - expectedConfidence).abs() < epsilon;
        })),
      );

      await service.processImage(mockCameraImage, mockRotation);
    });

     test(
        'processImage should emit openMouth gesture based on refined logic', () async {
       // Arrange: Create landmarks representing an open mouth
       // Mouth width: 360-280 = 80
       // Mouth corners avg Y: (280+280)/2 = 280
       // Mouth bottom Y: 315
       // Mouth opening: 315 - 280 = 35
       // Ratio: 35 / 80 = 0.4375 ( > threshold 0.35)
       // Confidence: min(1.0, (0.4375 - 0.35) / (0.6 - 0.35)) = min(1.0, 0.0875 / 0.25) = 0.35
       final openMouthFace = _createMockFace(
         landmarks: {
           FaceLandmarkType.bottomMouth: _createLandmark(320, 315),
           FaceLandmarkType.leftMouth: _createLandmark(280, 280),
           FaceLandmarkType.rightMouth: _createLandmark(360, 280),
           // Include eye landmarks for height calculation fallback if needed
           FaceLandmarkType.leftEye: _createLandmark(290, 240),
           FaceLandmarkType.rightEye: _createLandmark(350, 240),
         }
       );
       when(mockDetector.processImage(any))
           .thenAnswer((_) async => [openMouthFace]);

       // Act & Assert
       expectLater(
         service.gestureStream,
         emits(predicate<List<FacialGesture>>((gestures) {
           final openMouthGesture = gestures.firstWhere((g) => g.type == GestureType.openMouth, orElse: () => FacialGesture(type: GestureType.smile, confidence: -1, timestamp: DateTime.now()));
           final expectedConfidence = 0.35;
           final epsilon = 0.01;
           return openMouthGesture.type == GestureType.openMouth &&
                  (openMouthGesture.confidence - expectedConfidence).abs() < epsilon;
         })),
       );
       await service.processImage(mockCameraImage, mockRotation);
    });

    test(
        'processImage should emit frown gesture based on refined logic', () async {
       // Arrange: Create landmarks for a frown
       // Eye center Y: (240+240)/2 = 240
       // Mouth bottom Y: 290 (used for height estimate)
       // Face height estimate: 290 - 240 = 50
       // Nose base Y: 270
       // Left Corner Y rel: (280 - 270) / 50 = 0.2
       // Right Corner Y rel: (280 - 270) / 50 = 0.2
       // Avg Corner Y rel: (0.2 + 0.2) / 2 = 0.2 ( > threshold 0.08)
       // Confidence: min(1.0, (0.2 - 0.08) / (0.2 - 0.08)) = min(1.0, 0.12 / 0.12) = 1.0
       final frowningFace = _createMockFace(
         landmarks: {
           FaceLandmarkType.leftMouth: _createLandmark(280, 280),
           FaceLandmarkType.rightMouth: _createLandmark(360, 280),
           FaceLandmarkType.noseBase: _createLandmark(320, 270),
           FaceLandmarkType.leftEye: _createLandmark(290, 240), // Needed for height estimate
           FaceLandmarkType.rightEye: _createLandmark(350, 240),
           FaceLandmarkType.bottomMouth: _createLandmark(320, 290), // Needed for height estimate
         }
       );
       when(mockDetector.processImage(any))
           .thenAnswer((_) async => [frowningFace]);

       // Act & Assert
       expectLater(
         service.gestureStream,
         emits(predicate<List<FacialGesture>>((gestures) {
           final frownGesture = gestures.firstWhere((g) => g.type == GestureType.frown, orElse: () => FacialGesture(type: GestureType.smile, confidence: -1, timestamp: DateTime.now()));
           final expectedConfidence = 1.0;
           final epsilon = 0.01;
           return frownGesture.type == GestureType.frown &&
                  (frownGesture.confidence - expectedConfidence).abs() < epsilon;
         })),
       );
       await service.processImage(mockCameraImage, mockRotation);
    });

    test('processImage handles empty face list', () async {
        when(mockDetector.processImage(any)).thenAnswer((_) async => []);

        expectLater(
            service.gestureStream,
            emits(predicate<List<FacialGesture>>((gestures) => gestures.isEmpty)),
        );

        await service.processImage(mockCameraImage, mockRotation);
    });

     test('processImage handles face with null probabilities/landmarks', () async {
        final nullFace = _createMockFace(); // No probabilities or landmarks
        when(mockDetector.processImage(any)).thenAnswer((_) async => [nullFace]);

         expectLater(
            service.gestureStream,
            emits(predicate<List<FacialGesture>>((gestures) => gestures.isEmpty)),
        );

        await service.processImage(mockCameraImage, mockRotation);
    });

  });
}

// Removed manual MockPlane and MockCameraImageFormat classes as @GenerateMocks handles them
