import 'package:freezed_annotation/freezed_annotation.dart';

part 'motion_counts.freezed.dart';

@freezed
class MotionCounts with _$MotionCounts {
  const factory MotionCounts({
    @Default(0) int rollCount,
    @Default(0) int yawCount,
    @Default(0) int dropCount,
  }) = _MotionCounts;
}
