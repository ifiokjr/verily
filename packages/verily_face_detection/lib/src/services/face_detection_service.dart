import 'dart:async';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rxdart/rxdart.dart';

import '../models/facial_gesture.dart';

/// Service responsible for detecting facial gestures using ML Kit Face Detection
class FaceDetectionService {
  FaceDetectionService() {
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  late final FaceDetector _detector;
  final _gestureController = BehaviorSubject<List<FacialGesture>>();

  /// Stream of detected facial gestures
  Stream<List<FacialGesture>> get gestureStream => _gestureController.stream;

  /// Process a camera image and detect facial gestures
  Future<void> processImage(CameraImage image, InputImageRotation rotation) async {
    final inputImage = _convertCameraImageToInputImage(image, rotation);
    if (inputImage == null) return;

    final faces = await _detector.processImage(inputImage);
    final gestures = <FacialGesture>[];
    final now = DateTime.now();

    for (final face in faces) {
      if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
        gestures.add(FacialGesture(
          type: GestureType.smile,
          confidence: face.smilingProbability!,
          timestamp: now,
        ));
      }

      // Detect blink by checking left and right eye open probabilities
      if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null) {
        final leftEyeClosed = face.leftEyeOpenProbability! < 0.1;
        final rightEyeClosed = face.rightEyeOpenProbability! < 0.1;

        if (leftEyeClosed && rightEyeClosed) {
          gestures.add(FacialGesture(
            type: GestureType.blink,
            confidence: 1 - (face.leftEyeOpenProbability! + face.rightEyeOpenProbability!) / 2,
            timestamp: now,
          ));
        } else if (leftEyeClosed || rightEyeClosed) {
          gestures.add(FacialGesture(
            type: GestureType.wink,
            confidence: leftEyeClosed
                ? 1 - face.leftEyeOpenProbability!
                : 1 - face.rightEyeOpenProbability!,
            timestamp: now,
          ));
        }
      }

      // Additional gesture detection logic will be implemented here
      // TODO: Implement detection for frown, open mouth, and tongue out
    }

    _gestureController.add(gestures);
  }

  /// Convert CameraImage to InputImage for ML Kit processing
  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    // TODO: Implement conversion logic based on platform
    // This will require platform-specific code for iOS and Android
    return null;
  }

  /// Dispose of resources
  void dispose() {
    _detector.close();
    _gestureController.close();
  }
}
