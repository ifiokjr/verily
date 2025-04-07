import 'dart:async';
import 'dart:math' as math; // Use prefix for clarity
import 'package:sensors_plus/sensors_plus.dart';

/// Represents the type of motion detected by the [MotionDetectorService].
enum MotionEventType {
  /// A drop event, detected by a period of freefall followed by a significant impact.
  drop,

  /// A rotation around the Z-axis (vertical axis when phone is upright).
  /// The exact angle threshold is determined by [MotionDetectorService.yawSensitivity].
  yaw, // Renamed from fullYaw for clarity
  /// A rotation around the Y-axis (horizontal axis when phone is upright).
  /// The exact angle threshold is determined by [MotionDetectorService.rollSensitivity].
  roll, // Renamed from fullRoll for clarity
}

/// Indicates the direction of a detected rotation event.
enum RotationDirection { clockwise, counterClockwise }

/// Contains details about a detected motion event.
class MotionEvent {
  /// The type of motion detected.
  final MotionEventType type;

  /// The timestamp when the event was detected.
  final DateTime timestamp;

  /// An optional value associated with the event.
  /// For [MotionEventType.drop], this represents the impact magnitude (m/s²).
  /// For rotation events, this is currently unused but could represent angle/rate.
  final double? value;

  /// For rotation events ([MotionEventType.yaw], [MotionEventType.roll]),
  /// indicates the direction of the rotation. Null for drop events.
  final RotationDirection? direction;

  MotionEvent(this.type, this.timestamp, {this.value, this.direction})
    : assert(
        type == MotionEventType.drop || direction != null,
        'Rotation direction must be provided for yaw and roll events.',
      );

  @override
  String toString() {
    String directionString = direction != null ? ', direction: $direction' : '';
    return 'MotionEvent(type: $type, timestamp: $timestamp, value: ${value?.toStringAsFixed(2)}$directionString)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotionEvent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          timestamp == other.timestamp &&
          value == other.value &&
          direction == other.direction; // Added direction

  @override
  int get hashCode =>
      type.hashCode ^ timestamp.hashCode ^ value.hashCode ^ direction.hashCode; // Added direction
}

/// Service to detect specific phone motions like drops, full yaw rotations,
/// and full roll rotations using accelerometer and gyroscope data.
///
/// This service listens to sensor events and processes them to identify
/// predefined motion patterns. Detected events are broadcasted via the
/// [motionEvents] stream.
class MotionDetectorService {
  // --- Constants ---
  /// Base impact threshold (m/s²) used for calculating the effective threshold.
  static const double _baseImpactThreshold = 25.0;

  /// Base rotation angle threshold (radians, equivalent to 360 degrees).
  static const double _baseRotationThreshold = 2 * math.pi;

  // --- Configuration ---

  /// The threshold (in m/s²) below which acceleration magnitude is considered freefall.
  /// Slightly increased default for potentially noisy freefall simulations.
  /// Defaults to 2.0 m/s².
  final double freefallThreshold;

  /// The minimum duration of freefall required before checking for an impact.
  /// Defaults to 150 milliseconds.
  final Duration freefallTimeThreshold;

  /// Sensitivity factor for drop detection. Defaults to 2.0 (twice the base sensitivity).
  /// - Values > 1.0 increase sensitivity (lower impact force needed).
  /// - Values < 1.0 decrease sensitivity (higher impact force needed).
  /// Must be greater than 0.
  final double dropSensitivity;

  /// Sensitivity factor for yaw rotation detection. Defaults to 0.75 (270 degrees).
  /// Determines the fraction of a full 360-degree rotation required to trigger a yaw event.
  /// - Value of 1.0 requires a full 360 degrees.
  /// - Value of 0.5 requires 180 degrees.
  /// Must be between 0 and 1 (exclusive of 0).
  final double yawSensitivity;

  /// Sensitivity factor for roll rotation detection. Defaults to 0.75 (270 degrees).
  /// Determines the fraction of a full 360-degree rotation required to trigger a roll event.
  /// - Value of 1.0 requires a full 360 degrees.
  /// - Value of 0.5 requires 180 degrees.
  /// Must be between 0 and 1 (exclusive of 0).
  final double rollSensitivity;

  /// The time window after a potential freefall ends, during which an impact spike is checked for.
  /// Defaults to 500 milliseconds.
  final Duration impactDetectionWindow;

  /// The threshold (in radians/sec) below which the rotation rate is considered stopped,
  /// causing the accumulated rotation angle to reset. Defaults to 0.1 rad/s.
  final double rotationRateStopThreshold;

  /// The cooldown duration after a motion event is detected, during which subsequent
  /// detections of the *same* type are ignored. This prevents rapid re-triggering.
  /// Defaults to 1 second.
  final Duration detectionResetDelay;

  // --- Calculated Internal Configuration ---
  /// The effective impact threshold calculated based on the base value and sensitivity.
  late final double _effectiveImpactThreshold;

  /// The effective yaw rotation threshold calculated based on the base value and sensitivity.
  late final double _effectiveYawThreshold;

  /// The effective roll rotation threshold calculated based on the base value and sensitivity.
  late final double _effectiveRollThreshold;

  // --- Sensor Subscriptions ---
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _impactSubscription;
  Timer? _impactTimer;

  // --- State Variables ---
  // Drop Detection
  bool _inPotentialFreefall = false;
  DateTime? _potentialFreefallStartTime;

  // Rotation Detection
  DateTime? _lastGyroTimestamp;
  double _accumulatedYaw = 0.0;
  double _accumulatedRoll = 0.0;

  // Flags to prevent rapid re-triggering during the cooldown period
  bool _isDropDetectionCooldown = false;
  bool _isYawDetectionCooldown = false;
  bool _isRollDetectionCooldown = false;

  // --- Event Streams ---
  // Controller for broadcasting detected motion events. Uses a broadcast stream
  // to allow multiple listeners.
  final StreamController<MotionEvent> _motionEventController =
      StreamController<MotionEvent>.broadcast();

  /// A broadcast stream providing [MotionEvent] objects when a detection occurs.
  /// Listen to this stream to react to drop, full yaw, or full roll events.
  Stream<MotionEvent> get motionEvents => _motionEventController.stream;

  /// Creates a [MotionDetectorService] instance.
  ///
  /// Allows customization of various detection thresholds and timings.
  /// Provides sensible defaults suitable for general use cases.
  MotionDetectorService({
    // Drop detection parameters
    this.freefallThreshold = 2.0, // Increased default freefall threshold
    this.freefallTimeThreshold = const Duration(milliseconds: 150),
    this.dropSensitivity = 2.0, // Default increased sensitivity
    this.impactDetectionWindow = const Duration(milliseconds: 500),
    // Rotation detection parameters
    this.yawSensitivity = 0.75, // Default to 270 degrees
    this.rollSensitivity = 0.75, // Default to 270 degrees
    this.rotationRateStopThreshold = 0.1, // radians/sec
    // General parameters
    this.detectionResetDelay = const Duration(
      seconds: 1,
    ), // Default cooldown reduced to 1s
  }) : assert(freefallThreshold >= 0, 'freefallThreshold must be non-negative'),
       assert(dropSensitivity > 0, 'dropSensitivity must be positive'),
       assert(
         yawSensitivity > 0 && yawSensitivity <= 1.0,
         'yawSensitivity must be between 0 (exclusive) and 1.0 (inclusive)',
       ),
       assert(
         rollSensitivity > 0 && rollSensitivity <= 1.0,
         'rollSensitivity must be between 0 (exclusive) and 1.0 (inclusive)',
       ),
       assert(
         rotationRateStopThreshold >= 0,
         'rotationRateStopThreshold must be non-negative',
       ) {
    // Calculate the effective thresholds based on base values and sensitivities.
    _effectiveImpactThreshold = _baseImpactThreshold / dropSensitivity;
    _effectiveYawThreshold = _baseRotationThreshold * yawSensitivity;
    _effectiveRollThreshold = _baseRotationThreshold * rollSensitivity;
    print(
      '[MotionDetector] Initialized. DropSens: $dropSensitivity, EffectiveImpactThr: ${_effectiveImpactThreshold.toStringAsFixed(2)}, FreefallThr: ${freefallThreshold.toStringAsFixed(2)}, Cooldown: ${detectionResetDelay.inSeconds}s',
    );
  }

  /// Starts listening to accelerometer and gyroscope sensors.
  ///
  /// This method initializes the sensor streams and begins the detection process.
  /// It should be called before expecting any events on the [motionEvents] stream.
  /// If already listening, this method does nothing.
  void startListening() {
    // Prevent multiple initializations
    if (_accelerometerSubscription != null || _gyroscopeSubscription != null) {
      // Optionally log or handle this case if needed
      // print("MotionDetectorService: Already listening.");
      return;
    }

    // Reset state variables in case of restart
    _resetState();

    // --- Start Accelerometer Listener ---
    // Uses normal interval for general motion and freefall start detection.
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      _handleAccelerometerEvent,
      onError: _handleAccelerometerError,
      cancelOnError: false,
    ); // Keep listening on error if possible

    // --- Start Gyroscope Listener ---
    // Uses UI interval, suitable for smooth rotation tracking.
    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      _handleGyroscopeEvent,
      onError: _handleGyroscopeError,
      cancelOnError: false,
    ); // Keep listening on error if possible

    // print("MotionDetectorService: Started listening to sensors."); // Optional logging
  }

  /// Stops listening to sensors and releases associated resources.
  ///
  /// It's crucial to call this method when the service is no longer needed
  /// (e.g., in a Flutter widget's dispose method) to prevent memory leaks
  /// and unnecessary battery consumption.
  /// This also closes the [motionEvents] stream.
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _impactSubscription?.cancel();
    _impactTimer?.cancel();

    // Only close the controller if it's not already closed
    if (!_motionEventController.isClosed) {
      _motionEventController.close();
    }

    // Nullify subscriptions to indicate they are stopped
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _impactSubscription = null;
    _impactTimer = null;

    // print("MotionDetectorService: Stopped listening and disposed resources."); // Optional logging
  }

  /// Resets internal state variables to their initial values.
  /// Called internally when starting to listen.
  void _resetState() {
    _inPotentialFreefall = false;
    _potentialFreefallStartTime = null;
    _lastGyroTimestamp = null;
    _accumulatedYaw = 0.0;
    _accumulatedRoll = 0.0;
    _isDropDetectionCooldown = false;
    _isYawDetectionCooldown = false;
    _isRollDetectionCooldown = false;
  }

  // --- Event Handlers ---

  /// Processes incoming accelerometer events for freefall detection.
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    if (_accelerometerSubscription == null) return;
    double magnitude = math.sqrt(
      math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2),
    );
    final now = DateTime.now();
    // DEBUG: Print magnitude frequently to see baseline and spikes
    // print('[MotionDetector Accel] Mag: ${magnitude.toStringAsFixed(2)}');

    // --- Potential Freefall Detection Logic ---
    if (magnitude < freefallThreshold) {
      if (!_inPotentialFreefall) {
        _inPotentialFreefall = true;
        _potentialFreefallStartTime = now;
        print(
          '[MotionDetector Drop] >>> Potential Freefall STARTED (Mag: ${magnitude.toStringAsFixed(2)} < ${freefallThreshold.toStringAsFixed(2)}) @ $now',
        );
      }
      // else: Already in potential freefall, just continue
    } else {
      // Acceleration is above freefall threshold
      if (_inPotentialFreefall) {
        // We *were* in freefall, now check duration and look for impact
        final freefallDuration = now.difference(_potentialFreefallStartTime!);
        print(
          '[MotionDetector Drop] <<< Potential Freefall ENDED (Mag: ${magnitude.toStringAsFixed(2)} >= ${freefallThreshold.toStringAsFixed(2)}). Duration: $freefallDuration @ $now',
        );

        _inPotentialFreefall =
            false; // Reset freefall state *before* checking impact
        _potentialFreefallStartTime = null;

        if (freefallDuration >= freefallTimeThreshold) {
          print(
            '[MotionDetector Drop] --- Freefall Duration OK ($freefallDuration >= $freefallTimeThreshold). Checking for impact...',
          );
          _checkForImpact(now);
        } else {
          print(
            '[MotionDetector Drop] --- Freefall Duration TOO SHORT ($freefallDuration < $freefallTimeThreshold). No impact check.',
          );
        }
      } // else: we were not in freefall, so just ignore normal acceleration readings
    }
  }

  /// Processes incoming gyroscope events for yaw and roll detection.
  void _handleGyroscopeEvent(GyroscopeEvent event) {
    // Protect against processing events after disposal
    if (_gyroscopeSubscription == null) return;

    final now = DateTime.now();
    // Gyroscope reports rotation rate in radians per second.
    double yawRate = event.z; // Z-axis rotation (around vertical axis)
    double rollRate =
        event
            .y; // Y-axis rotation (around horizontal axis - tilting left/right)
    // Note: Pitch (X-axis) is event.x, but not used here.

    // Calculate time delta since the last event for integration.
    if (_lastGyroTimestamp != null) {
      // Time difference in seconds.
      final double timeDelta =
          now.difference(_lastGyroTimestamp!).inMilliseconds / 1000.0;

      // --- Yaw Calculation --- Updated to use _effectiveYawThreshold
      _accumulatedYaw = _updateAccumulatedRotation(
        _accumulatedYaw,
        yawRate,
        timeDelta,
        MotionEventType.yaw,
        _isYawDetectionCooldown,
      );

      if (!_isYawDetectionCooldown &&
          _accumulatedYaw.abs() >= _effectiveYawThreshold) {
        final direction =
            _accumulatedYaw > 0
                ? RotationDirection.counterClockwise
                : RotationDirection.clockwise;
        _emitMotionEvent(MotionEventType.yaw, now, direction: direction);
        _isYawDetectionCooldown = true; // Start cooldown
        // Reset using modulo to handle continuous rotation correctly
        _accumulatedYaw %=
            _effectiveYawThreshold; // Keep the remainder relative to the threshold
        Timer(detectionResetDelay, () => _isYawDetectionCooldown = false);
      }

      // --- Roll Calculation --- Updated to use _effectiveRollThreshold
      _accumulatedRoll = _updateAccumulatedRotation(
        _accumulatedRoll,
        rollRate,
        timeDelta,
        MotionEventType.roll,
        _isRollDetectionCooldown,
      );

      if (!_isRollDetectionCooldown &&
          _accumulatedRoll.abs() >= _effectiveRollThreshold) {
        final direction =
            _accumulatedRoll > 0
                ? RotationDirection.clockwise
                : RotationDirection.counterClockwise;
        _emitMotionEvent(MotionEventType.roll, now, direction: direction);
        _isRollDetectionCooldown = true; // Start cooldown
        // Reset using modulo to handle continuous rotation correctly
        _accumulatedRoll %=
            _effectiveRollThreshold; // Keep the remainder relative to the threshold
        Timer(detectionResetDelay, () => _isRollDetectionCooldown = false);
      }
    }
    // Store the timestamp of the current event for the next calculation.
    _lastGyroTimestamp = now;
  }

  /// Helper method to update an accumulated rotation angle.
  ///
  /// Integrates the rotation rate over the time delta and adds it to the
  /// accumulated angle. Resets the accumulated angle to zero if the rotation
  /// rate drops below the [rotationRateStopThreshold] for a sustained period
  /// (implicitly handled by continuous calls) or if accumulation is negligible.
  /// Accumulation is skipped if the corresponding cooldown flag is active.
  ///
  /// Returns the updated accumulated angle.
  double _updateAccumulatedRotation(
    double accumulatedAngle,
    double rate,
    double timeDelta,
    MotionEventType type,
    bool isCooldown,
  ) {
    // Integrate the angle change, but only if not in cooldown for this motion type.
    if (!isCooldown) {
      accumulatedAngle += (rate * timeDelta);
    }

    // If the rotation rate is very low (effectively stopped),
    // reset the accumulator to prevent slow drift from noise.
    // The accumulatedAngle check prevents resetting constantly when already near zero.
    if (rate.abs() < rotationRateStopThreshold &&
        accumulatedAngle.abs() > 0.01) {
      // print("${type.name} rate below threshold, resetting accumulated angle from $accumulatedAngle"); // Debug
      return 0.0; // Reset due to stopped rotation
    }

    // Optional: Add a check to reset if the angle itself becomes near zero after integration,
    // regardless of rate, to handle potential over/undershoot corrections.
    // if (accumulatedAngle.abs() < 0.01) {
    //   return 0.0;
    // }

    return accumulatedAngle; // Return the updated or potentially reset angle
  }

  /// Initiates a check for an impact spike immediately following a potential freefall.
  void _checkForImpact(DateTime freefallEndTime) {
    if (_isDropDetectionCooldown) {
      print('[MotionDetector Drop] !!! Impact check skipped: Cooldown active.');
      return;
    }

    _impactSubscription?.cancel();
    _impactTimer?.cancel();

    print(
      '[MotionDetector Drop] === Starting Impact Check Window (${impactDetectionWindow.inMilliseconds}ms) ===',
    );
    bool impactDetectedInThisCheck = false;

    _impactSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.fastestInterval,
    ).listen(
      (AccelerometerEvent event) {
        if (_impactSubscription == null || impactDetectedInThisCheck) return;

        double magnitude = math.sqrt(
          math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2),
        );
        final now = DateTime.now();
        final timeSinceFreefallEnd = now.difference(freefallEndTime);

        print(
          '[MotionDetector Impact Check] Accel Mag: ${magnitude.toStringAsFixed(2)} (Time since freefall end: ${timeSinceFreefallEnd.inMilliseconds}ms)',
        );

        // --- Impact Detection ---
        if (magnitude > _effectiveImpactThreshold) {
          print(
            '[MotionDetector Drop] +++ IMPACT DETECTED! Mag: ${magnitude.toStringAsFixed(2)} > Threshold: ${_effectiveImpactThreshold.toStringAsFixed(2)}',
          );
          impactDetectedInThisCheck = true;
          _emitMotionEvent(MotionEventType.drop, now, value: magnitude);

          _isDropDetectionCooldown = true;
          print(
            '[MotionDetector Drop] *** Cooldown Started (${detectionResetDelay.inSeconds}s) ***',
          );
          Timer(detectionResetDelay, () {
            print(
              '[MotionDetector Drop] *** Cooldown Finished (${detectionResetDelay.inSeconds}s) ***',
            );
            _isDropDetectionCooldown = false;
          });

          _impactSubscription?.cancel();
          _impactTimer?.cancel();
          _impactSubscription = null;
          _impactTimer = null;
          return;
        }

        // --- Window Timeout Check (within listener) ---
        if (timeSinceFreefallEnd > impactDetectionWindow) {
          print(
            '[MotionDetector Drop] --- Impact window passed (${timeSinceFreefallEnd.inMilliseconds}ms > ${impactDetectionWindow.inMilliseconds}ms). Cancelling check.',
          );
          _impactSubscription?.cancel();
          _impactTimer?.cancel();
          _impactSubscription = null;
          _impactTimer = null;
          return;
        }
      },
      onError: (error) {
        print("[MotionDetector Impact Check] Error: $error");
        _impactSubscription?.cancel();
        _impactTimer?.cancel();
        _impactSubscription = null;
        _impactTimer = null;
      },
      cancelOnError: true,
    );

    // --- Safety Timer ---
    _impactTimer = Timer(
      impactDetectionWindow + const Duration(milliseconds: 50),
      () {
        if (_impactSubscription != null) {
          print(
            '[MotionDetector Drop] --- Impact safety timer fired. Cancelling check.',
          );
          _impactSubscription?.cancel();
          _impactSubscription = null;
          _impactTimer = null;
        }
      },
    );
  }

  /// Adds a [MotionEvent] to the broadcast stream controller if it's not closed.
  void _emitMotionEvent(
    MotionEventType type,
    DateTime timestamp, {
    double? value,
    RotationDirection? direction,
  }) {
    if (!_motionEventController.isClosed) {
      print(
        '[MotionDetector] >>> Emitting Event: $type',
      ); // DEBUG: Confirm emission
      if ((type == MotionEventType.yaw || type == MotionEventType.roll) &&
          direction == null) {
        print("Error: Rotation direction missing for $type event.");
        return;
      }
      final event = MotionEvent(
        type,
        timestamp,
        value: value,
        direction: direction,
      );
      _motionEventController.add(event);
    } else {
      print(
        '[MotionDetector] ??? Attempted to emit event on closed controller: $type',
      );
    }
  }

  // --- Error Handlers ---

  /// Handles errors from the main accelerometer stream.
  void _handleAccelerometerError(dynamic error) {
    print("Accelerometer Stream Error: $error");
    // Consider more robust error handling: retry mechanism, logging to analytics, etc.
    // For now, we just print the error. The subscription might stop depending on cancelOnError.
    // If cancelOnError is false, we might want to manually cancel/reset here depending on the error type.
  }

  /// Handles errors from the gyroscope stream.
  void _handleGyroscopeError(dynamic error) {
    print("Gyroscope Stream Error: $error");
    // Similar considerations as the accelerometer error handler.
  }
}
