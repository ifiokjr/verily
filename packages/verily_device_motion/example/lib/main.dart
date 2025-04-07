import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

import 'motion_counts.dart';

// Custom hook to manage the MotionDetectorService with sensitivity parameters
MotionDetectorService useMotionDetector({
  required double dropSensitivity,
  required double yawSensitivity,
  required double rollSensitivity,
}) {
  // Create a ref to store the detector service
  final detectorRef = useRef<MotionDetectorService?>(null);

  // Setup and dispose the detector on widget lifecycle
  useEffect(() {
    // Initialize on first build with the provided sensitivities
    detectorRef.value = MotionDetectorService(
      dropSensitivity: dropSensitivity,
      yawSensitivity: yawSensitivity,
      rollSensitivity: rollSensitivity,
    );
    detectorRef.value!.startListening();
    print('MotionDetectorService initialized/updated with sensitivities: drop=$dropSensitivity, yaw=$yawSensitivity, roll=$rollSensitivity');

    // Dispose on widget disposal
    return () {
      print('Disposing MotionDetectorService...');
      detectorRef.value?.dispose();
      detectorRef.value = null;
    };
    // Re-run effect if any sensitivity changes
  }, [dropSensitivity, yawSensitivity, rollSensitivity]);

  // We assert non-null because useEffect runs synchronously on first build
  return detectorRef.value!;
}

// Provider for the motion counts
final motionCountsProvider = StateProvider<MotionCounts>((ref) => const MotionCounts());

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
    // State for sensitivity sliders
    final dropSensitivity = useState<double>(1.0);
    final yawSensitivity = useState<double>(0.75); // Default from service
    final rollSensitivity = useState<double>(0.75); // Default from service

    // Get the motion detector service using our custom hook, passing sensitivities
    final motionDetector = useMotionDetector(
      dropSensitivity: dropSensitivity.value,
      yawSensitivity: yawSensitivity.value,
      rollSensitivity: rollSensitivity.value,
    );

    // Get current counts from provider
    final counts = ref.watch(motionCountsProvider);

    // Listen to motion events using useEffect
    useEffect(() {
      final subscription = motionDetector.motionEvents.listen((event) {
        print("Received Motion Event: $event"); // Debugging
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
      }, onError: (e) => print("Error in motion stream: $e"));

      // Clean up subscription
      return () {
        print("Cancelling motion subscription...");
        subscription.cancel();
      };
    }, [motionDetector]); // Re-subscribe if the detector instance changes

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
        child: ListView( // Use ListView for scrollability
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
              label: 'Drop Sensitivity',
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
              label: 'Yaw Sensitivity (Threshold: ${(yawSensitivity.value * 360).toStringAsFixed(0)}°)',
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
              label: 'Roll Sensitivity (Threshold: ${(rollSensitivity.value * 360).toStringAsFixed(0)}°)',
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
