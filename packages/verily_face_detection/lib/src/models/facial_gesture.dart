import 'package:freezed_annotation/freezed_annotation.dart';

part 'facial_gesture.freezed.dart';
part 'facial_gesture.g.dart';

/// Represents different types of facial gestures that can be detected
enum GestureType {
  smile,
  wink,
  blink,
  frown,
  openMouth,
  tongueOut,
}

/// Represents a detected facial gesture with its type and confidence score
@freezed
class FacialGesture with _$FacialGesture {
  const factory FacialGesture({
    required GestureType type,
    required double confidence,
    required DateTime timestamp,
  }) = _FacialGesture;

  factory FacialGesture.fromJson(Map<String, dynamic> json) =>
      _$FacialGestureFromJson(json);
}
