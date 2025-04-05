// Simple class to track motion counts without requiring code generation
class MotionCounts {
  final int rollCount;
  final int yawCount;
  final int dropCount;

  const MotionCounts({
    this.rollCount = 0,
    this.yawCount = 0,
    this.dropCount = 0,
  });

  // Manual copyWith implementation
  MotionCounts copyWith({
    int? rollCount,
    int? yawCount,
    int? dropCount,
  }) {
    return MotionCounts(
      rollCount: rollCount ?? this.rollCount,
      yawCount: yawCount ?? this.yawCount,
      dropCount: dropCount ?? this.dropCount,
    );
  }
}
