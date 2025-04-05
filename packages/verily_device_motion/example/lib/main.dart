import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

import 'motion_counts.dart';

// Custom hook to manage the MotionDetectorService
MotionDetectorService useMotionDetector() {
  // Create a ref to store the detector service
  final detectorRef = useRef<MotionDetectorService?>(null);

  // Setup and dispose the detector on widget lifecycle
  useEffect(() {
    // Initialize on first build
    detectorRef.value = MotionDetectorService();
    detectorRef.value!.startListening();

    // Dispose on widget disposal
    return () {
      detectorRef.value?.dispose();
      detectorRef.value = null;
    };
  }, const []); // Empty dependency array means this only runs once on init

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
    // Get the motion detector service using our custom hook
    final motionDetector = useMotionDetector();

    // Get current counts from provider
    final counts = ref.watch(motionCountsProvider);

    // Listen to motion events using useEffect
    useEffect(() {
      // Set up stream subscription
      final subscription = motionDetector.motionEvents.listen((event) {
        switch (event.type) {
          case MotionEventType.fullRoll:
            ref.read(motionCountsProvider.notifier).update(
              (state) => state.copyWith(rollCount: state.rollCount + 1)
            );
            break;
          case MotionEventType.fullYaw:
            ref.read(motionCountsProvider.notifier).update(
              (state) => state.copyWith(yawCount: state.yawCount + 1)
            );
            break;
          case MotionEventType.drop:
            ref.read(motionCountsProvider.notifier).update(
              (state) => state.copyWith(dropCount: state.dropCount + 1)
            );
            break;
        }
      });

      // Clean up subscription
      return () {
        subscription.cancel();
      };
    }, [motionDetector]); // Depends on the motion detector

    // Reset function using hooks
    final resetCounts = useCallback(() {
      ref.read(motionCountsProvider.notifier).state = const MotionCounts();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verily Motion Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Device Motion Events Detected:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildCounterRow('Rolls', counts.rollCount),
            _buildCounterRow('Yaws', counts.yawCount),
            _buildCounterRow('Drops', counts.dropCount),
          ],
        ),
      ),
      // Use resetCounts created with useCallback
      floatingActionButton: FloatingActionButton(
        onPressed: resetCounts,
        tooltip: 'Reset Counts',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Helper widget to display a counter row consistently
  Widget _buildCounterRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '$count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
