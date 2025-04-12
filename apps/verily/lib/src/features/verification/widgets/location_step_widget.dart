import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the location verification step.
class LocationStepWidget extends ConsumerWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const LocationStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual location checking logic
    // - Request location permissions
    // - Get current location
    // - Compare with parameters['latitude'], parameters['longitude'], parameters['radius']
    // - Call notifier.reportStepSuccess or notifier.reportStepFailure

    final latitude = parameters['latitude'] ?? 'N/A';
    final longitude = parameters['longitude'] ?? 'N/A';
    final radius = parameters['radius'] ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verify Location',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text('Target Latitude: $latitude'),
          Text('Target Longitude: $longitude'),
          Text('Required Radius (m): $radius'),
          const SizedBox(height: 32),
          const Text('Location check UI and logic goes here...'),
          const SizedBox(height: 32),
          // Add buttons for simulation until logic is implemented
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed:
                    () => notifier.reportStepSuccess('Location Verified'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Simulate Success'),
              ),
              ElevatedButton(
                onPressed: () => notifier.reportStepFailure('Outside radius'),
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
