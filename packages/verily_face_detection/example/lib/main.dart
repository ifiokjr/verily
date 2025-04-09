import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:permission_handler/permission_handler.dart';
import 'package:verily_face_detection/verily_face_detection.dart';

// Global variable for cameras (consider moving to a provider if scaling)
late List<CameraDescription> _cameras;

// Provider for the FaceDetectionService
final faceDetectionServiceProvider = Provider.autoDispose<FaceDetectionService>((ref) {
  final service = FaceDetectionService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Provider for the available cameras (async)
final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  try {
    return await availableCameras();
  } catch (e) {
    debugPrint('Error initializing cameras: $e');
    return []; // Return empty list on error
  }
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize cameras here or rely on the provider
  // _cameras = await availableCameras(); // Can be removed if using provider only
  runApp(const ProviderScope(child: MyApp())); // Wrap with ProviderScope
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Dark theme for better contrast
      ),
      home: const FaceDetectionPage(),
    );
  }
}

// Change to HookConsumerWidget
class FaceDetectionPage extends HookConsumerWidget {
  const FaceDetectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Management with Hooks & Riverpod ---
    final faceDetectionService = ref.watch(faceDetectionServiceProvider);
    final camerasAsyncValue = ref.watch(camerasProvider);

    // State for camera controller, selected camera, permission, and detection status
    final cameraControllerState = useState<CameraController?>(null);
    final selectedCameraState = useState<CameraDescription?>(null);
    final permissionStatusState = useState<PermissionStatus>(PermissionStatus.denied);
    final isDetectingState = useState<bool>(false);
    final detectedGesturesState = useState<List<FacialGesture>>([]);
    final errorState = useState<String?>(null);

    // --- Hooks for Side Effects (useEffect) ---

    // Effect for checking and requesting permissions
    useEffect(() {
      Future<void> checkAndRequestPermission() async {
        final status = await Permission.camera.status;
        permissionStatusState.value = status;
        if (!status.isGranted) {
          final requestedStatus = await Permission.camera.request();
          permissionStatusState.value = requestedStatus;
          if (!requestedStatus.isGranted) {
             errorState.value = "Camera permission denied.";
          }
        }
      }
      checkAndRequestPermission();
      return null; // No cleanup needed for permission check
    }, []); // Run only once

    // Effect for initializing camera when permission is granted and cameras are available
    useEffect(() {
      CameraController? controller;
      CameraDescription? cameraToUse;

      Future<void> initialize() async {
        if (permissionStatusState.value.isGranted && camerasAsyncValue.hasValue && camerasAsyncValue.value!.isNotEmpty) {
          _cameras = camerasAsyncValue.value!;
          // Prefer front camera
          cameraToUse = _cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras.first,
          );
          selectedCameraState.value = cameraToUse;

          // Dispose previous controller if exists
          await cameraControllerState.value?.dispose();

          controller = CameraController(
            cameraToUse!,
            ResolutionPreset.medium,
            enableAudio: false,
            imageFormatGroup: ImageFormatGroup.nv21,
          );

          try {
            await controller!.initialize();
            if (!context.mounted) return; // Check mounted after async gap
            cameraControllerState.value = controller; // Update state with initialized controller

            await controller!.startImageStream((image) {
                _processCameraImage(image, selectedCameraState.value, faceDetectionService, isDetectingState);
            });
            isDetectingState.value = true;
            errorState.value = null; // Clear previous errors

          } on CameraException catch (e) {
            debugPrint('Error initializing camera: ${e.code} - ${e.description}');
            errorState.value = 'Failed to initialize camera: ${e.description}';
            isDetectingState.value = false;
            cameraControllerState.value = null; // Clear controller on error
          } catch (e) {
            debugPrint('Unexpected error initializing camera: $e');
            errorState.value = 'An unexpected error occurred: $e';
            isDetectingState.value = false;
             cameraControllerState.value = null;
          }
        }
      }

      initialize();

      // Cleanup function: Disposes the camera controller
      return () async {
        isDetectingState.value = false;
        try {
            await controller?.stopImageStream();
        } catch (e) {
            debugPrint("Error stopping image stream: $e");
        }
        await controller?.dispose();
      };
    }, [permissionStatusState.value, camerasAsyncValue]); // Re-run if permission or cameras change

    // --- Hook for Listening to Gesture Stream ---
    // Use useStream hook to listen to the gesture stream
    final gestureStream = useMemoized(() => faceDetectionService.gestureStream, [faceDetectionService]);
    final gesturesSnapshot = useStream<List<FacialGesture>>(gestureStream, initialData: []);

    // Update state when stream emits new data
    // Using useEffect to update state based on stream snapshot avoids build errors
    useEffect(() {
      if (gesturesSnapshot.hasData) {
        detectedGesturesState.value = gesturesSnapshot.data!;
      }
      return null;
    }, [gesturesSnapshot.data]);


    // --- Build UI ---
    Widget buildCameraPreview() {
       if (errorState.value != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: ${errorState.value}', style: const TextStyle(color: Colors.red)),
          )
        );
      }

      if (permissionStatusState.value.isDenied || permissionStatusState.value.isPermanentlyDenied) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Camera permission is required.'),
              const SizedBox(height: 16),
              ElevatedButton(
                // Re-trigger permission check/request
                onPressed: () async {
                    final status = await Permission.camera.request();
                    permissionStatusState.value = status;
                    if (!status.isGranted && status.isPermanentlyDenied) {
                       await openAppSettings();
                    }
                },
                child: Text(permissionStatusState.value.isPermanentlyDenied ? 'Open Settings' : 'Grant Permission'),
              ),
            ],
          ),
        );
      }

      final controller = cameraControllerState.value;
      if (controller == null || !controller.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      final size = MediaQuery.of(context).size;
      var scale = size.aspectRatio * controller.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;

      return Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(controller),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection (Hooks)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: buildCameraPreview(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              detectedGesturesState.value.isEmpty
                  ? 'Detected Gestures: None'
                  : 'Detected Gestures: ${detectedGesturesState.value.map((g) => g.type.name).join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted image processing logic to avoid capturing `this` in closure
void _processCameraImage(
    CameraImage image,
    CameraDescription? cameraDescription,
    FaceDetectionService faceDetectionService,
    ValueNotifier<bool> isDetectingState,
) async {
  if (!isDetectingState.value || cameraDescription == null) return;

  final rotation = _getInputImageRotation(cameraDescription.sensorOrientation);

  try {
    // Make sure to only process if detection is still active
    if (isDetectingState.value) {
        await faceDetectionService.processImage(image, rotation);
    }
  } catch (e) {
    debugPrint("Error processing image: $e");
    // Optionally handle error (e.g., update an error state provider)
    // Consider stopping detection if errors persist
    // isDetectingState.value = false;
  }
}

// Helper function remains the same
InputImageRotation _getInputImageRotation(int sensorOrientation) {
  switch (sensorOrientation) {
    case 0:
      return InputImageRotation.rotation0deg;
    case 90:
      return InputImageRotation.rotation90deg;
    case 180:
      return InputImageRotation.rotation180deg;
    case 270:
      return InputImageRotation.rotation270deg;
    default:
      return InputImageRotation.rotation0deg;
  }
}
