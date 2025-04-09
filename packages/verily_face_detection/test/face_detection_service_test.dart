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
      // Mock raw value if needed by the converter logic directly (though group is usually enough)
      // when(mockFormat.raw).thenReturn(somePlatformSpecificValue); // e.g., 35 for Android YUV_420_888

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
          return gestures.length == 1 &&
                 gestures.first.type == GestureType.blink &&
                 gestures.first.confidence == closeTo(0.95, 0.001); // 1 - (0.05+0.05)/2
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
          return gestures.length == 1 &&
                 gestures.first.type == GestureType.wink &&
                 gestures.first.confidence == closeTo(0.95, 0.001); // 1 - 0.05
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
          return gestures.length == 1 &&
                 gestures.first.type == GestureType.wink &&
                 gestures.first.confidence == closeTo(0.95, 0.001); // 1 - 0.05
        })),
      );

      await service.processImage(mockCameraImage, mockRotation);
    });

     test(
        'processImage should emit openMouth gesture based on landmarks', () async {
        final openMouthFace = _createMockFace(
          landmarks: {
            FaceLandmarkType.bottomMouth: _createLandmark(320, 300),
            FaceLandmarkType.noseBase: _createLandmark(320, 250),
          }
        );
       when(mockDetector.processImage(any))
          .thenAnswer((_) async => [openMouthFace]);

       // Simple expectation, confidence calculation might need adjustment
       expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          return gestures.any((g) => g.type == GestureType.openMouth && g.confidence > 0);
        })),
      );
       await service.processImage(mockCameraImage, mockRotation);
    });

     test(
        'processImage should emit frown gesture based on landmarks', () async {
        final frowningFace = _createMockFace(
          landmarks: {
            FaceLandmarkType.leftMouth: _createLandmark(280, 280),
            FaceLandmarkType.rightMouth: _createLandmark(360, 280),
            FaceLandmarkType.noseBase: _createLandmark(320, 270), // Nose base slightly higher than corners
          }
        );
        when(mockDetector.processImage(any))
            .thenAnswer((_) async => [frowningFace]);

        expectLater(
        service.gestureStream,
        emits(predicate<List<FacialGesture>>((gestures) {
          return gestures.any((g) => g.type == GestureType.frown && g.confidence > 0);
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
