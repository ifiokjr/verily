import 'dart:async';
import 'dart:math' as math; // Use prefix for clarity
import 'package:sensors_plus/sensors_plus.dart';

/// Represents the type of motion detected by the [MotionDetectorService].
enum MotionEventType {
  /// A drop event, detected by a period of freefall followed by a significant impact.
  drop,

  /// A full 360-degree rotation around the Z-axis (vertical axis when phone is upright).
  fullYaw,

  /// A full 360-degree rotation around the Y-axis (horizontal axis when phone is upright).
  fullRoll
}

/// Contains details about a detected motion event.
class MotionEvent {
  /// The type of motion detected.
  final MotionEventType type;

  /// The timestamp when the event was detected.
  final DateTime timestamp;

  /// An optional value associated with the event.
  /// For [MotionEventType.drop], this represents the impact magnitude (m/s²).
  /// For rotation events, this is currently unused.
  final double? value;

  MotionEvent(this.type, this.timestamp, {this.value});

  @override
  String toString() {
    return 'MotionEvent(type: $type, timestamp: $timestamp, value: ${value?.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotionEvent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          timestamp == other.timestamp &&
          value == other.value;

  @override
  int get hashCode => type.hashCode ^ timestamp.hashCode ^ value.hashCode;
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

  // --- Configuration ---

  /// The threshold (in m/s²) below which acceleration magnitude is considered freefall.
  /// Defaults to 1.5 m/s².
  final double freefallThreshold;

  /// The minimum duration of freefall required before checking for an impact.
  /// Defaults to 150 milliseconds.
  final Duration freefallTimeThreshold;

  /// Sensitivity factor for drop detection. Defaults to 1.0.
  /// - Values > 1.0 increase sensitivity (lower impact force needed to trigger a drop).
  /// - Values < 1.0 decrease sensitivity (higher impact force needed).
  /// - A value of 0.5 requires roughly twice the default impact force.
  /// - A value of 2.0 requires roughly half the default impact force.
  /// Must be greater than 0.
  final double dropSensitivity;

  /// The time window after a potential freefall ends, during which an impact spike is checked for.
  /// Defaults to 500 milliseconds.
  final Duration impactDetectionWindow;

  /// The threshold (in radians/sec) below which the rotation rate is considered stopped,
  /// causing the accumulated rotation angle to reset. Defaults to 0.1 rad/s.
  final double rotationRateStopThreshold;

  /// The threshold (in radians) for detecting a full rotation (yaw or roll).
  /// Slightly less than 2π (360 degrees) to account for potential sensor noise.
  /// Defaults to approximately 353 degrees (2 * pi * 0.98).
  final double fullRotationThreshold;

  /// The cooldown duration after a motion event is detected, during which subsequent
  /// detections of the *same* type are ignored. This prevents rapid re-triggering.
  /// Defaults to 3 seconds.
  final Duration detectionResetDelay;

  // --- Calculated Internal Configuration ---
  /// The effective impact threshold calculated based on the base value and sensitivity.
  late final double _effectiveImpactThreshold;

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
    this.freefallThreshold = 1.5, // m/s^2
    this.freefallTimeThreshold = const Duration(milliseconds: 150),
    this.dropSensitivity = 1.0,
    this.impactDetectionWindow = const Duration(milliseconds: 500),
    // Rotation detection parameters
    this.rotationRateStopThreshold = 0.1, // radians/sec
    this.fullRotationThreshold = 2 * math.pi * 0.98, // ~353 degrees in radians
    // General parameters
    this.detectionResetDelay = const Duration(seconds: 3), // Cooldown period
  }) : assert(freefallThreshold >= 0, 'freefallThreshold must be non-negative'),
       assert(dropSensitivity > 0, 'dropSensitivity must be positive'),
       assert(rotationRateStopThreshold >= 0, 'rotationRateStopThreshold must be non-negative'),
       assert(fullRotationThreshold > 0, 'fullRotationThreshold must be positive')
  {
    // Calculate the effective threshold based on sensitivity.
    // Higher sensitivity means lower threshold.
    _effectiveImpactThreshold = _baseImpactThreshold / dropSensitivity;
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
    _accelerometerSubscription =
        accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval)
            .listen(_handleAccelerometerEvent,
                onError: _handleAccelerometerError, cancelOnError: false); // Keep listening on error if possible

    // --- Start Gyroscope Listener ---
    // Uses UI interval, suitable for smooth rotation tracking.
    _gyroscopeSubscription =
        gyroscopeEventStream(samplingPeriod: SensorInterval.uiInterval)
            .listen(_handleGyroscopeEvent,
                onError: _handleGyroscopeError, cancelOnError: false); // Keep listening on error if possible

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
    // Protect against processing events after disposal
    if (_accelerometerSubscription == null) return;

    // Calculate the magnitude of the acceleration vector.
    double magnitude = math.sqrt(
        math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2));
    final now = DateTime.now();

    // --- Potential Freefall Detection Logic ---
    if (magnitude < freefallThreshold) {
      // If we weren't already in potential freefall, mark the start time.
      if (!_inPotentialFreefall) {
        _inPotentialFreefall = true;
        _potentialFreefallStartTime = now;
        // print("Potential freefall started"); // Debug log
      }
    } else {
      // If we *were* in potential freefall (i.e., acceleration is now above threshold)
      if (_inPotentialFreefall) {
        // Calculate how long the potential freefall lasted.
        final freefallDuration = now.difference(_potentialFreefallStartTime!);

        // If the duration meets the threshold, proceed to check for an impact.
        if (freefallDuration >= freefallTimeThreshold) {
          // print("Freefall duration threshold met ($freefallDuration), checking for impact..."); // Debug log
          _checkForImpact(now); // Check immediately after freefall ends
        } else {
          // print("Freefall too short ($freefallDuration)"); // Debug log
        }

        // Reset freefall state regardless of duration, as it has ended.
        _inPotentialFreefall = false;
        _potentialFreefallStartTime = null;
      }
      // Optional: Log high G spikes even if not part of a drop sequence
      // This could be useful for other analyses but is commented out for clarity.
      // Use the *calculated* effective threshold here for comparison if logging.
      // if (magnitude > _effectiveImpactThreshold) {
      //   print("High acceleration spike detected (not necessarily impact): $magnitude");
      // }
    }
  }

  /// Processes incoming gyroscope events for yaw and roll detection.
  void _handleGyroscopeEvent(GyroscopeEvent event) {
    // Protect against processing events after disposal
    if (_gyroscopeSubscription == null) return;

    final now = DateTime.now();
    // Gyroscope reports rotation rate in radians per second.
    double yawRate = event.z; // Z-axis rotation (around vertical axis)
    double rollRate = event.y; // Y-axis rotation (around horizontal axis - tilting left/right)
    // Note: Pitch (X-axis) is event.x, but not used here.

    // Calculate time delta since the last event for integration.
    if (_lastGyroTimestamp != null) {
      // Time difference in seconds.
      final double timeDelta =
          now.difference(_lastGyroTimestamp!).inMilliseconds / 1000.0;

      // --- Yaw Calculation ---
      // Update the accumulated yaw angle based on the current rate and time delta.
      // Also handles resetting if rotation stops.
      _accumulatedYaw = _updateAccumulatedRotation(_accumulatedYaw, yawRate,
          timeDelta, MotionEventType.fullYaw, _isYawDetectionCooldown);

      // Check if a full yaw rotation has occurred and we're not in cooldown.
      if (!_isYawDetectionCooldown &&
          _accumulatedYaw.abs() >= fullRotationThreshold) {
        _emitMotionEvent(MotionEventType.fullYaw, now);
        _isYawDetectionCooldown = true; // Start cooldown
        _accumulatedYaw %= (2 * math.pi); // Keep the remainder for continuous tracking
        // Schedule the cooldown reset.
        Timer(detectionResetDelay, () => _isYawDetectionCooldown = false);
      }

      // --- Roll Calculation ---
      // Update the accumulated roll angle.
      _accumulatedRoll = _updateAccumulatedRotation(_accumulatedRoll,
          rollRate, timeDelta, MotionEventType.fullRoll, _isRollDetectionCooldown);

      // Check if a full roll rotation has occurred and we're not in cooldown.
      if (!_isRollDetectionCooldown &&
          _accumulatedRoll.abs() >= fullRotationThreshold) {
        _emitMotionEvent(MotionEventType.fullRoll, now);
        _isRollDetectionCooldown = true; // Start cooldown
        _accumulatedRoll %= (2 * math.pi); // Keep the remainder
        // Schedule the cooldown reset.
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
  /// rate drops below the [rotationRateStopThreshold].
  /// Accumulation is skipped if the corresponding cooldown flag is active.
  ///
  /// Returns the updated accumulated angle.
  double _updateAccumulatedRotation(double accumulatedAngle, double rate,
      double timeDelta, MotionEventType type, bool isCooldown) {

    // Integrate the angle change, but only if not in cooldown for this motion type.
    if (!isCooldown) {
      accumulatedAngle += (rate * timeDelta);
    }

    // If the rotation rate is very low (effectively stopped) and there was
    // some accumulated angle, reset the accumulator.
    // Check accumulatedAngle magnitude to avoid resetting constantly at 0.
    if (rate.abs() < rotationRateStopThreshold && accumulatedAngle.abs() > 0.01) {
       // print("${type.name} rate below threshold, resetting accumulated angle from $accumulatedAngle"); // Debug
      return 0.0; // Reset
    }

    return accumulatedAngle; // Return the updated or potentially reset angle
  }

  /// Initiates a check for an impact spike immediately following a potential freefall.
  ///
  /// Listens to the accelerometer at a high frequency for a short duration
  /// ([impactDetectionWindow]) to catch the characteristic high-G spike of an impact.
  void _checkForImpact(DateTime freefallEndTime) {
    // Don't check for impact if drop detection is currently in its cooldown period.
    if (_isDropDetectionCooldown) {
      // print("Drop detection cooldown active, skipping impact check."); // Debug
      return;
    }

    // Cancel any previous impact check that might still be running (safety measure).
    _impactSubscription?.cancel();
    _impactTimer?.cancel();

    // print("Starting impact detection listener..."); // Debug

    // Listen briefly for a high-G spike using the fastest possible sensor interval.
    _impactSubscription = accelerometerEventStream(
            // Use fastest interval for better chance of catching brief impact spike
            samplingPeriod: SensorInterval.fastestInterval)
        .listen(
      (AccelerometerEvent event) {
        // Protect against processing events after disposal or cancellation
        if (_impactSubscription == null) return;

        double magnitude = math.sqrt(
            math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2));

        // --- Impact Detection ---
        // Use the calculated effective impact threshold here
        if (magnitude > _effectiveImpactThreshold) {
          // print("Impact Detected! Magnitude: $magnitude (Threshold: $_effectiveImpactThreshold)"); // Debug
          // Emit the drop event with the impact magnitude.
          _emitMotionEvent(MotionEventType.drop, DateTime.now(), value: magnitude);

          // Start cooldown for drop detection to prevent immediate re-triggering.
          _isDropDetectionCooldown = true;
          Timer(detectionResetDelay, () => _isDropDetectionCooldown = false);

          // Successfully detected impact, stop listening immediately.
          _impactSubscription?.cancel();
          _impactTimer?.cancel(); // Cancel the safety timer as well
          _impactSubscription = null; // Mark as cancelled
          _impactTimer = null;
        }

        // --- Window Timeout Check (within listener) ---
        // Also check if the detection window has passed *during* this event handling.
        // This ensures we stop promptly if the window closes between events.
        if (DateTime.now().difference(freefallEndTime) > impactDetectionWindow) {
          // print("Impact detection window passed within listener, cancelling."); // Debug
          _impactSubscription?.cancel();
          _impactTimer?.cancel(); // Cancel the safety timer
          _impactSubscription = null; // Mark as cancelled
          _impactTimer = null;
          // print("Freefall detected, but no subsequent impact spike within window."); // Log info
        }
      },
      onError: (error) {
        // Handle errors during the brief impact listening phase.
        print("Impact Accelerometer Error: $error");
        _impactSubscription?.cancel();
        _impactTimer?.cancel();
        _impactSubscription = null;
        _impactTimer = null;
      },
      cancelOnError: true, // Stop listening if an error occurs during impact check
    );

    // --- Safety Timer ---
    // Ensures the impact listener is *always* cancelled if no impact is detected
    // within the allowed window, even if no further accelerometer events arrive.
    // Add a small buffer to the duration.
    _impactTimer = Timer(impactDetectionWindow + const Duration(milliseconds: 50), () {
      // This timer callback executes only if the impact listener wasn't already cancelled.
      if (_impactSubscription != null) {
        // print("Impact detection window timed out via Timer, cancelling."); // Debug
        _impactSubscription?.cancel();
        _impactSubscription = null;
        _impactTimer = null; // Timer fulfilled its purpose
        // print("Freefall detected, but no subsequent impact spike within window (timer)."); // Log info
      }
    });
  }

  /// Adds a [MotionEvent] to the broadcast stream controller if it's not closed.
  void _emitMotionEvent(MotionEventType type, DateTime timestamp, {double? value}) {
    if (!_motionEventController.isClosed) {
      final event = MotionEvent(type, timestamp, value: value);
      _motionEventController.add(event);
      // print("Motion Detected: $event"); // Optional: Log detected events
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
