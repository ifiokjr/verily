import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the smile detection step.
class SmileStepWidget extends ConsumerWidget {
  // Parameters might not be needed for smile detection, but kept for consistency
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const SmileStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual smile detection logic
    // - Initialize camera
    // - Display camera preview
    // - Use verily_face_detection package to detect smile
    // - Call notifier.reportStepSuccess or notifier.reportStepFailure

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Smile at the Camera',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          // Placeholder for Camera Preview
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(child: Text('Camera Preview Area')),
          ),
          const SizedBox(height: 32),
          const Text('Smile detection UI and logic goes here...'),
          const SizedBox(height: 32),
          // Add buttons for simulation until logic is implemented
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => notifier.reportStepSuccess('Smile Detected'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Simulate Success'),
              ),
              ElevatedButton(
                onPressed:
                    () => notifier.reportStepFailure('No smile detected'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Simulate Failure'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
