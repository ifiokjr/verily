// Simple class to track motion counts
class MotionCounts {
  // Drop Count
  final int dropCount;

  // Yaw Counts
  final int yawCwCount;
  final int yawCcwCount;

  // Roll Counts
  final int rollCwCount;
  final int rollCcwCount;

  const MotionCounts({
    this.dropCount = 0,
    this.yawCwCount = 0,
    this.yawCcwCount = 0,
    this.rollCwCount = 0,
    this.rollCcwCount = 0,
  });

  // Manual copyWith implementation
  MotionCounts copyWith({
    int? dropCount,
    int? yawCwCount,
    int? yawCcwCount,
    int? rollCwCount,
    int? rollCcwCount,
  }) {
    return MotionCounts(
      dropCount: dropCount ?? this.dropCount,
      yawCwCount: yawCwCount ?? this.yawCwCount,
      yawCcwCount: yawCcwCount ?? this.yawCcwCount,
      rollCwCount: rollCwCount ?? this.rollCwCount,
      rollCcwCount: rollCcwCount ?? this.rollCcwCount,
    );
  }

  // Helper getters for total counts (optional)
  int get totalYaw => yawCwCount + yawCcwCount;
  int get totalRoll => rollCwCount + rollCcwCount;
}
