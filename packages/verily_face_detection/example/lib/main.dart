import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import 'package:verily_face_detection/verily_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; // For InputImageRotation

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } catch (e) {
    print('Error initializing cameras: $e');
    return; // Exit if cameras can't be initialized
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FaceDetectionPage(),
    );
  }
}

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  CameraController? _controller;
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  List<FacialGesture> _detectedGestures = [];
  StreamSubscription? _gestureSubscription;
  bool _isDetecting = false;
  CameraDescription? _selectedCamera;
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();

    // Listen to gesture stream
    _gestureSubscription = _faceDetectionService.gestureStream.listen((gestures) {
      if (mounted) {
        setState(() {
          _detectedGestures = gestures;
        });
      }
    });
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _cameraPermissionStatus = status;
    });
    if (status.isGranted) {
      _initializeCameraAndDetection();
    } else {
      // Optionally request immediately or show a button
       _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionStatus = status;
    });
    if (status.isGranted) {
      _initializeCameraAndDetection();
    }
  }

  Future<void> _initializeCameraAndDetection() async {
    if (_cameras.isEmpty) {
      print("No cameras available");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No cameras found on this device.")),
      );
      return;
    }

    // Prefer front camera if available
    _selectedCamera = _cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );
    await _initializeCamera(_selectedCamera!);
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    // Dispose existing controller first if any
    await _controller?.dispose();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Explicitly set format if needed
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream(_processCameraImage);
      setState(() {
        _isDetecting = true;
      });
    } on CameraException catch (e) {
       print('Error initializing camera: ${e.code} - ${e.description}');
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Failed to initialize camera: ${e.description}')),
       );
       setState(() { _isDetecting = false; }); // Ensure detection stops
    } catch (e) {
      print('Unexpected error initializing camera: $e');
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('An unexpected error occurred: $e')),
       );
       setState(() { _isDetecting = false; });
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!_isDetecting) return;

    final rotation = _getInputImageRotation(
      _selectedCamera!.sensorOrientation,
    );

    try {
      await _faceDetectionService.processImage(image, rotation);
    } catch (e) {
      print("Error processing image: $e");
      // Optionally stop detection on error
      // setState(() { _isDetecting = false; });
    }
  }

  // Helper to convert sensor orientation to InputImageRotation
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

  @override
  void dispose() {
    _gestureSubscription?.cancel();
    _isDetecting = false; // Ensure processing stops
    _controller?.stopImageStream().catchError((e) {
      print("Error stopping image stream: $e"); // Log error if stream stop fails
    });
    _controller?.dispose();
    _faceDetectionService.dispose();
    super.dispose();
  }

  Widget _buildCameraPreview() {
    if (_cameraPermissionStatus.isDenied || _cameraPermissionStatus.isPermanentlyDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Camera permission is required to detect faces.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestCameraPermission,
              child: const Text('Grant Permission'),
            ),
            if (_cameraPermissionStatus.isPermanentlyDenied)
              ElevatedButton(
                onPressed: openAppSettings,
                child: const Text('Open Settings'),
              ),
          ],
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Calculate aspect ratio for CameraPreview
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller!),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Gesture Detection Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: _buildCameraPreview(),
            ),
          ),
          // Detected Gestures Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _detectedGestures.isEmpty
                  ? 'Detected Gestures: None'
                  : 'Detected Gestures: ${_detectedGestures.map((g) => g.type.name).join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
