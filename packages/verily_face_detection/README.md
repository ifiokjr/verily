<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Verily Face Detection

A Flutter package for real-time facial gesture detection and tracking, part of the Verily SDK. This package uses Google's ML Kit Face Detection to recognize various facial gestures including smiles, winks, blinks, frowns, open mouths, and tongue protrusions.

## Features

- Real-time facial gesture detection
- Support for multiple facial gestures:
  - Smile detection
  - Wink detection (left/right eye)
  - Blink detection
  - Frown detection
  - Open mouth detection
  - Tongue out detection
- Stream-based API for continuous gesture updates
- High accuracy using ML Kit's face detection capabilities
- Cross-platform support (iOS and Android)

## Getting Started

### Prerequisites

Ensure you have the following in your `pubspec.yaml`:

```yaml
dependencies:
  verily_face_detection: ^0.0.1
```

### Usage

1. Initialize the face detection service:

```dart
final faceDetectionService = FaceDetectionService();
```

2. Listen to the gesture stream:

```dart
faceDetectionService.gestureStream.listen((gestures) {
  for (final gesture in gestures) {
    print('Detected ${gesture.type} with confidence ${gesture.confidence}');
  }
});
```

3. Process camera frames:

```dart
// In your camera preview callback:
void onCameraFrame(CameraImage image, InputImageRotation rotation) {
  await faceDetectionService.processImage(image, rotation);
}
```

4. Clean up resources:

```dart
@override
void dispose() {
  faceDetectionService.dispose();
  super.dispose();
}
```

## Example

Check the example directory for a complete sample application demonstrating facial gesture detection.

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
