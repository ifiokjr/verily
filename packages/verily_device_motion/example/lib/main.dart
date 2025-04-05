import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'motion_provider.dart';

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

class MotionCounterScreen extends ConsumerWidget {
  const MotionCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the motion counter provider to get the current counts
    final counts = ref.watch(motionCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verily Motion Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
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
      // Optional: Add a button to reset counts
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(motionCounterProvider.notifier).resetCounts(),
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
