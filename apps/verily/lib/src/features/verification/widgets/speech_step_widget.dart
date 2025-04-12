import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the speech recognition step.
class SpeechStepWidget extends ConsumerWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const SpeechStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual speech recognition logic
    // - Request microphone permissions
    // - Initialize speech recognizer (e.g., speech_to_text package)
    // - Provide button to start/stop listening
    // - Compare recognized text with parameters['phrase']
    // - Call notifier.reportStepSuccess or notifier.reportStepFailure

    final requiredPhrase = parameters['phrase'] ?? '[Phrase not specified]';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Speech Recognition',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text('Please say the following phrase clearly:'),
          const SizedBox(height: 8),
          Text(
            '"$requiredPhrase"',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Placeholder for microphone button and status
          Icon(Icons.mic_none, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          const Text('Tap microphone to start/stop recording'),
          const SizedBox(height: 32),
          // Add buttons for simulation until logic is implemented
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => notifier.reportStepSuccess('Phrase Matched'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Simulate Success'),
              ),
              ElevatedButton(
                onPressed: () => notifier.reportStepFailure('Incorrect phrase'),
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
