import 'dart:async';
import 'dart:math' show Point, max, min;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Needed for ImageRotation
import 'package:google_mlkit_commons/google_mlkit_commons.dart' as ml_commons;

import '../models/facial_gesture.dart';

/// Service responsible for detecting facial gestures using ML Kit Face Detection
class FaceDetectionService {
  /// Creates an instance of [FaceDetectionService].
  ///
  /// Optionally accepts a [FaceDetector] for testing purposes.
  FaceDetectionService({FaceDetector? detector}) {
    _detector =
        detector ??
        FaceDetector(
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
  Future<void> processImage(
    CameraImage image,
    InputImageRotation rotation,
  ) async {
    final inputImage = _convertCameraImageToInputImage(image, rotation);
    if (inputImage == null) return;

    final faces = await _detector.processImage(inputImage);
    final gestures = <FacialGesture>[];
    final now = DateTime.now();

    for (final face in faces) {
      if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
        gestures.add(
          FacialGesture(
            type: GestureType.smile,
            confidence: face.smilingProbability!,
            timestamp: now,
          ),
        );
      }

      // Detect blink by checking left and right eye open probabilities
      if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null) {
        final leftEyeClosed = face.leftEyeOpenProbability! < 0.1;
        final rightEyeClosed = face.rightEyeOpenProbability! < 0.1;

        if (leftEyeClosed && rightEyeClosed) {
          gestures.add(
            FacialGesture(
              type: GestureType.blink,
              confidence:
                  1 -
                  (face.leftEyeOpenProbability! +
                          face.rightEyeOpenProbability!) /
                      2,
              timestamp: now,
            ),
          );
        } else if (leftEyeClosed || rightEyeClosed) {
          gestures.add(
            FacialGesture(
              type: GestureType.wink,
              confidence:
                  leftEyeClosed
                      ? 1 - face.leftEyeOpenProbability!
                      : 1 - face.rightEyeOpenProbability!,
              timestamp: now,
            ),
          );
        }
      }

      // --- Landmark Extraction ---
      final Point<int>? mouthBottom =
          face.landmarks[FaceLandmarkType.bottomMouth]?.position;
      final Point<int>? mouthLeft =
          face.landmarks[FaceLandmarkType.leftMouth]?.position;
      final Point<int>? mouthRight =
          face.landmarks[FaceLandmarkType.rightMouth]?.position;
      final Point<int>? noseBase =
          face.landmarks[FaceLandmarkType.noseBase]?.position;
      final Point<int>? leftEye =
          face.landmarks[FaceLandmarkType.leftEye]?.position;
      final Point<int>? rightEye =
          face.landmarks[FaceLandmarkType.rightEye]?.position;

      // --- Calculations ---
      // Estimate face height (eye line to mouth bottom) for normalization, if possible
      double faceHeightEstimate = 0.0;
      if (leftEye != null && rightEye != null && mouthBottom != null) {
        final double eyeCenterY = (leftEye.y + rightEye.y) / 2.0;
        faceHeightEstimate = (mouthBottom.y - eyeCenterY).abs().toDouble();
      } else if (noseBase != null && mouthBottom != null) {
        // Fallback
        faceHeightEstimate = (mouthBottom.y - noseBase.y).abs().toDouble();
      }

      // Estimate mouth width
      double mouthWidthEstimate = 0.0;
      if (mouthLeft != null && mouthRight != null) {
        mouthWidthEstimate = (mouthRight.x - mouthLeft.x).abs().toDouble();
      }

      // --- Gesture Detection ---

      // Detect Open Mouth (Refined)
      // Compare vertical distance between bottom lip and mouth corners line,
      // normalized by mouth width.
      if (mouthBottom != null &&
          mouthLeft != null &&
          mouthRight != null &&
          mouthWidthEstimate > 1) {
        // Avoid division by zero/small width
        final double mouthCornerYAvg = (mouthLeft.y + mouthRight.y) / 2.0;
        final double mouthOpening = (mouthBottom.y - mouthCornerYAvg).abs();
        final double mouthOpenRatio = mouthOpening / mouthWidthEstimate;

        const double mouthOpenThreshold =
            0.35; // Heuristic: Opening is > 35% of mouth width

        if (mouthOpenRatio > mouthOpenThreshold) {
          gestures.add(
            FacialGesture(
              type: GestureType.openMouth,
              // Confidence based on how much it exceeds the threshold
              confidence: min(
                1.0,
                (mouthOpenRatio - mouthOpenThreshold) /
                    (0.6 - mouthOpenThreshold),
              ),
              timestamp: now,
            ),
          );
        }
      }

      // Detect Frown (Refined)
      // Check if mouth corners are significantly lower than the nose base,
      // normalized by estimated face height.
      if (mouthLeft != null &&
          mouthRight != null &&
          noseBase != null &&
          faceHeightEstimate > 1) {
        // Avoid division by zero/small height
        final double leftCornerRelY =
            (mouthLeft.y - noseBase.y) / faceHeightEstimate;
        final double rightCornerRelY =
            (mouthRight.y - noseBase.y) / faceHeightEstimate;

        // Positive value means the corner is lower than the nose base
        final double avgCornerRelY = (leftCornerRelY + rightCornerRelY) / 2.0;

        const double frownThreshold =
            0.08; // Heuristic: Corners > 8% of face height below nose

        if (avgCornerRelY > frownThreshold) {
          gestures.add(
            FacialGesture(
              type: GestureType.frown,
              // Confidence based on how much it exceeds the threshold
              confidence: min(
                1.0,
                (avgCornerRelY - frownThreshold) / (0.2 - frownThreshold),
              ),
              timestamp: now,
            ),
          );
        }
      }

      // TODO: Implement detection for tongue out (likely requires Face Mesh API)
      // ML Kit Face Detection landmarks are usually insufficient for tongue detection.
    }

    _gestureController.add(gestures);
  }

  /// Convert CameraImage to InputImage for ML Kit processing
  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    if (bytes.isEmpty) {
      debugPrint("Warning: Image bytes are empty.");
      return null;
    }

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final imageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    // Assumes the first plane contains the necessary row stride info
    final bytesPerRow =
        image.planes.isNotEmpty ? image.planes[0].bytesPerRow : 0;

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation, // Use the provided rotation
      format: imageFormat,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetadata, // Use metadata instead of inputImageData
    );
  }

  /// Dispose of resources
  void dispose() {
    _detector.close();
    _gestureController.close();
  }
}
