import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera/camera.dart';
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

  @override
  void initState() {
    super.initState();
    if (_cameras.isNotEmpty) {
      // Prefer front camera if available
      _selectedCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _initializeCamera(_selectedCamera!);
    } else {
      print("No cameras available");
    }

    // Listen to gesture stream
    _gestureSubscription = _faceDetectionService.gestureStream.listen((gestures) {
      if (mounted) {
        setState(() {
          _detectedGestures = gestures;
        });
      }
    });
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;

      // Start image stream
      await _controller!.startImageStream(_processCameraImage);
      setState(() {
        _isDetecting = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
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
    _controller?.stopImageStream();
    _controller?.dispose();
    _faceDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Gesture Detection'),
      ),
      body: Column(
        children: [
          // Camera Preview Placeholder
          Expanded(
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: _controller != null && _controller!.value.isInitialized
                  ? CameraPreview(_controller!) // Display camera preview
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          // Detected Gestures Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Detected Gestures: ${_detectedGestures.map((g) => g.type.name).join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
