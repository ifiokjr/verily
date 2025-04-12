import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_face_detection/verily_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the smile detection step.
class SmileStepWidget extends HookConsumerWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const SmileStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  // Helper to calculate rotation for ML Kit based on camera sensor orientation
  InputImageRotation _rotationFromCamera(
    CameraDescription cameraDesc,
    CameraController controller,
  ) {
    final sensorOrientation = cameraDesc.sensorOrientation;
    InputImageRotation rotation = InputImageRotation.rotation0deg;

    // Get device orientation if needed (can add later if rotation issues persist)
    // For now, assume portrait mode as default for mobile

    switch (sensorOrientation) {
      case 90:
        rotation = InputImageRotation.rotation90deg;
        break;
      case 180:
        rotation = InputImageRotation.rotation180deg;
        break;
      case 270:
        rotation = InputImageRotation.rotation270deg;
        break;
      default:
        rotation = InputImageRotation.rotation0deg;
    }
    // TODO: Consider device orientation if needed
    return rotation;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks Setup ---
    final camerasFuture = useMemoized(() => availableCameras());
    final camerasSnapshot = useFuture(camerasFuture);

    final cameraController = useState<CameraController?>(null);
    final isCameraInitialized = useState<bool>(false);
    final isProcessing = useState<bool>(false);
    final detectedSmile = useState<bool>(false);
    final errorMessage = useState<String?>(null);
    final reportedSuccess = useState<bool>(
      false,
    ); // Flag to prevent multiple reports

    // Memoize FaceDetectionService instance
    final faceDetectionService = useMemoized(() => FaceDetectionService());

    // --- Effects for Camera Initialization and Disposal ---
    useEffect(
      () {
        if (camerasSnapshot.hasData && camerasSnapshot.data!.isNotEmpty) {
          // Find the front camera
          final frontCamera = camerasSnapshot.data!.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
            orElse:
                () => camerasSnapshot.data!.first, // Fallback to first camera
          );

          final controller = CameraController(
            frontCamera,
            ResolutionPreset.medium, // Adjust resolution as needed
            enableAudio: false,
            imageFormatGroup: ImageFormatGroup.nv21, // Recommended for ML Kit
          );

          cameraController.value = controller;

          controller
              .initialize()
              .then((_) {
                if (!context.mounted) return;
                isCameraInitialized.value = true;
                errorMessage.value = null; // Clear previous errors

                // Start image stream for processing
                controller.startImageStream((CameraImage image) {
                  if (isProcessing.value) return; // Skip if already processing

                  isProcessing.value = true;
                  final rotation = _rotationFromCamera(frontCamera, controller);

                  faceDetectionService
                      .processImage(image, rotation)
                      .whenComplete(() {
                        if (context.mounted) {
                          isProcessing.value = false;
                        }
                      });
                });
              })
              .catchError((Object e) {
                if (context.mounted) {
                  debugPrint('Camera initialization error: $e');
                  errorMessage.value =
                      'Could not initialize camera: ${e.toString()}';
                  isCameraInitialized.value = false;
                }
              });
        } else if (camerasSnapshot.hasError) {
          debugPrint('Error fetching cameras: ${camerasSnapshot.error}');
          errorMessage.value =
              'Could not access cameras: ${camerasSnapshot.error.toString()}';
        }

        // Cleanup function: Dispose controller when widget is removed
        return () {
          cameraController.value?.stopImageStream();
          cameraController.value?.dispose();
        };
      },
      [camerasSnapshot.connectionState],
    ); // Re-run when camera list future resolves

    // --- Effect for FaceDetectionService Disposal ---
    useEffect(() {
      // Dispose the service when the widget is unmounted.
      return () => faceDetectionService.dispose();
    }, []); // Empty dependency array means run only on mount/unmount

    // --- Effect for Listening to Gesture Stream ---
    useEffect(
      () {
        final subscription = faceDetectionService.gestureStream.listen((
          gestures,
        ) {
          // Check if success has already been reported
          if (reportedSuccess.value) return;

          final smileDetectedCurrent = gestures.any(
            (g) => g.type == GestureType.smile && g.confidence > 0.75,
          ); // Threshold

          // Update UI feedback state regardless of reporting success
          detectedSmile.value = smileDetectedCurrent;

          if (smileDetectedCurrent) {
            // Stop the stream first
            cameraController.value
                ?.stopImageStream()
                .then((_) {
                  // Ensure we haven't already reported due to async nature
                  if (!reportedSuccess.value) {
                    reportedSuccess.value = true; // Set flag immediately
                    notifier.reportStepSuccess({
                      'smile_detected': true,
                      'confidence':
                          gestures
                              .firstWhere((g) => g.type == GestureType.smile)
                              .confidence,
                    });
                  }
                })
                .catchError((e) {
                  // Handle potential error stopping the stream (optional)
                  debugPrint("Error stopping image stream: $e");
                  // Still attempt to report success if not already done
                  if (!reportedSuccess.value) {
                    reportedSuccess.value = true; // Set flag immediately
                    notifier.reportStepSuccess({
                      'smile_detected': true,
                      'confidence':
                          gestures
                              .firstWhere((g) => g.type == GestureType.smile)
                              .confidence,
                    });
                  }
                });
          }
        });

        // Cleanup: Cancel subscription
        return () => subscription.cancel();
      },
      [faceDetectionService],
    ); // Re-run if service instance changes (it shouldn't)

    // --- UI Build ---
    Widget cameraPreviewWidget;
    if (errorMessage.value != null) {
      cameraPreviewWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            errorMessage.value!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (isCameraInitialized.value && cameraController.value != null) {
      cameraPreviewWidget = CameraPreview(cameraController.value!);
    } else {
      cameraPreviewWidget = const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Smile at the Camera',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Camera Preview Area with Aspect Ratio
          AspectRatio(
            aspectRatio:
                (isCameraInitialized.value && cameraController.value != null)
                    ? cameraController.value!.value.aspectRatio
                    : 1.0, // Default aspect ratio before init
            child: ClipRRect(
              // Optional: Add rounded corners
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    color: detectedSmile.value ? Colors.green : Colors.grey,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: cameraPreviewWidget,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Feedback Text
          Center(
            child: Text(
              detectedSmile.value
                  ? 'Smile Detected! Nicely done!'
                  : 'Keep smiling...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: detectedSmile.value ? Colors.green : Colors.grey[700],
              ),
            ),
          ),
          // Removed simulation buttons
          const Spacer(), // Push content up
        ],
      ),
    );
  }
}
