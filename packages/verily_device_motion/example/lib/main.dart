import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

import 'motion_counts.dart';

// Custom hook to manage the MotionDetectorService
// Creates the service instance ONLY ONCE when the hook mounts.
MotionDetectorService useMotionDetector({
  // Accept initial values for setup
  required double initialDropSensitivity,
  required double initialYawSensitivity,
  required double initialRollSensitivity,
}) {
  final detectorRef = useRef<MotionDetectorService?>(null);

  useEffect(() {
    // ONLY create on first mount
    print('[MotionDetector Hook] Creating detector instance ONCE...');
    detectorRef.value = MotionDetectorService(
      dropSensitivity: initialDropSensitivity,
      yawSensitivity: initialYawSensitivity,
      rollSensitivity: initialRollSensitivity,
      // You could also pass the reduced cooldown here if preferred,
      // but we'll change the default in the service itself.
      // detectionResetDelay: const Duration(seconds: 1),
    );
    detectorRef.value!.startListening();
    print(
        '[MotionDetector Hook] Initialized with sensitivities: drop=$initialDropSensitivity, yaw=$initialYawSensitivity, roll=$initialRollSensitivity');

    // Cleanup on unmount
    return () {
      print('[MotionDetector Hook] Disposing detector instance ON UNMOUNT...');
      detectorRef.value?.dispose();
      detectorRef.value = null;
    };
    // EMPTY dependency array ensures this runs only on mount and unmount
  }, const []);

  // The instance is guaranteed to be created by the time build runs
  return detectorRef.value!;
}

// Provider for the motion counts
final motionCountsProvider =
    StateProvider<MotionCounts>((ref) => const MotionCounts());

// Main app
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Wrap the app in ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verily Motion Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MotionCounterScreen(),
    );
  }
}

class MotionCounterScreen extends HookConsumerWidget {
  const MotionCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State for sensitivity sliders (initial values match service defaults)
    final dropSensitivity = useState<double>(2.0); // Matches new default
    final yawSensitivity = useState<double>(0.75);
    final rollSensitivity = useState<double>(0.75);

    // Get the motion detector service using our hook
    // Pass the INITIAL values from the state hooks.
    final motionDetector = useMotionDetector(
      initialDropSensitivity: dropSensitivity.value,
      initialYawSensitivity: yawSensitivity.value,
      initialRollSensitivity: rollSensitivity.value,
    );

    // Get current counts from provider
    final counts = ref.watch(motionCountsProvider);

    // Listen to motion events using useEffect
    useEffect(() {
      print("[Motion Event Listener] Subscribing to detector...");
      final subscription = motionDetector.motionEvents.listen((event) {
        // print("Received Motion Event: $event"); // Keep for debugging if needed
        ref.read(motionCountsProvider.notifier).update((state) {
          switch (event.type) {
            case MotionEventType.drop:
              return state.copyWith(dropCount: state.dropCount + 1);
            case MotionEventType.yaw:
              return event.direction == RotationDirection.clockwise
                  ? state.copyWith(yawCwCount: state.yawCwCount + 1)
                  : state.copyWith(yawCcwCount: state.yawCcwCount + 1);
            case MotionEventType.roll:
              return event.direction == RotationDirection.clockwise
                  ? state.copyWith(rollCwCount: state.rollCwCount + 1)
                  : state.copyWith(rollCcwCount: state.rollCcwCount + 1);
          }
        });
      }, onError: (e) => print("[Motion Event Listener] Error: $e"));

      // Clean up subscription on unmount or if detector changes (it shouldn't now)
      return () {
        print("[Motion Event Listener] Cancelling subscription...");
        subscription.cancel();
      };
      // Dependency array only includes motionDetector. It won't change now.
    }, [motionDetector]);

    // Reset function using hooks
    final resetCounts = useCallback(() {
      ref.read(motionCountsProvider.notifier).state = const MotionCounts();
    }, const []); // No dependencies needed for reset

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verily Motion Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counts',
            onPressed: resetCounts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Use ListView for scrollability
          children: <Widget>[
            Text(
              'Motion Event Counts',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // --- Drop Counter ---
            _buildCounterCard(
              title: 'Drops',
              count: counts.dropCount,
            ),
            const SizedBox(height: 10),
            _SensitivitySlider(
              label: 'Drop Sensitivity (Effective on Restart)',
              value: dropSensitivity.value,
              min: 0.1, // Avoid zero
              max: 5.0,
              divisions: 49,
              onChanged: (val) => dropSensitivity.value = val,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // --- Yaw Counters ---
            _buildDirectionalCounterCard(
              title: 'Yaw (Spin)',
              cwCount: counts.yawCwCount,
              ccwCount: counts.yawCcwCount,
            ),
            const SizedBox(height: 10),
            _SensitivitySlider(
              label:
                  'Yaw Sensitivity (Threshold: ${(yawSensitivity.value * 360).toStringAsFixed(0)}°, Effective on Restart)',
              value: yawSensitivity.value,
              min: 0.1, // ~36 degrees
              max: 1.0, // 360 degrees
              divisions: 9,
              onChanged: (val) => yawSensitivity.value = val,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // --- Roll Counters ---
            _buildDirectionalCounterCard(
              title: 'Roll (Barrel)',
              cwCount: counts.rollCwCount,
              ccwCount: counts.rollCcwCount,
            ),
            const SizedBox(height: 10),
            _SensitivitySlider(
              label:
                  'Roll Sensitivity (Threshold: ${(rollSensitivity.value * 360).toStringAsFixed(0)}°, Effective on Restart)',
              value: rollSensitivity.value,
              min: 0.1, // ~36 degrees
              max: 1.0, // 360 degrees
              divisions: 9,
              onChanged: (val) => rollSensitivity.value = val,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

// Simple counter card
class _buildCounterCard extends StatelessWidget {
  final String title;
  final int count;

  const _buildCounterCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('$count', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}

// Counter card showing CW and CCW counts
class _buildDirectionalCounterCard extends StatelessWidget {
  final String title;
  final int cwCount;
  final int ccwCount;

  const _buildDirectionalCounterCard({
    required this.title,
    required this.cwCount,
    required this.ccwCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('CW', style: textTheme.titleMedium),
                    Text('$cwCount', style: textTheme.headlineMedium),
                  ],
                ),
                Column(
                  children: [
                    Text('CCW', style: textTheme.titleMedium),
                    Text('$ccwCount', style: textTheme.headlineMedium),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Sensitivity Slider Widget
class _SensitivitySlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SensitivitySlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
