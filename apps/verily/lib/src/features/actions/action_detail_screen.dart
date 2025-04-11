import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Import actual action provider if needed to fetch full details
// import 'providers/action_providers.dart';

/// Screen to display the details and steps of a specific action.
class ActionDetailScreen extends ConsumerWidget {
  final int actionId;

  const ActionDetailScreen({required this.actionId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch the full action details using the actionId
    // For now, just display the ID.
    // final actionAsync = ref.watch(actionDetailProvider(actionId));

    return Scaffold(
      appBar: AppBar(
        // TODO: Replace with actual action name
        title: Text('Action Details (ID: $actionId)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for Action ID: $actionId'),
            const SizedBox(height: 20),
            // TODO: Display action steps here
            const Text('Steps will be listed here.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic to start the action verification
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting verification for Action ID: $actionId',
                    ),
                  ),
                );
              },
              child: const Text('Start Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
