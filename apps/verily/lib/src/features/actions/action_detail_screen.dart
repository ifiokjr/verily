import 'dart:convert'; // For jsonDecode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:verily_client/verily_client.dart' as vc;

import 'providers/action_providers.dart';
// Import the verification flow provider
import '../verification/providers/verification_flow_provider.dart';
import '../../routing/app_router.dart'; // Correct import for routing

/// Screen to display the details and steps of a specific action.
class ActionDetailScreen extends ConsumerWidget {
  final int actionId;

  const ActionDetailScreen({required this.actionId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the specific action details.
    final action = ref.watch(actionDetailProvider(actionId));

    // Handle case where action is not found or still loading (though provider is sync now)
    if (action == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Action Not Found')),
        body: const Center(child: Text('Could not load action details.')),
      );
    }

    // Action found, build the UI
    return Scaffold(
      appBar: AppBar(
        title: Text(action.name), // Use actual action name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(action.description ?? 'No description available.'),
            const SizedBox(height: 20),
            Text('Steps:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // Display the list of steps
            Expanded(
              child: _buildStepList(
                action.steps ?? [],
              ), // Handle potentially null steps
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Call the startFlow method on the provider
                  ref
                      .read(verificationFlowProvider.notifier)
                      .startFlow(actionId);

                  // Navigate to the verification screen
                  context.goNamed(
                    AppRouteNames.verifyAction,
                    pathParameters: {'actionId': actionId.toString()},
                  );
                },
                child: const Text('Start Verification'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the list of steps
  Widget _buildStepList(List<vc.ActionStep> steps) {
    if (steps.isEmpty) {
      return const Text('No steps defined for this action.');
    }

    // Sort steps by order
    steps.sort((a, b) => a.order.compareTo(b.order));

    return ListView.builder(
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        // Decode the parameters JSON string back into a Map
        Map<String, dynamic> params = {};
        try {
          if (step.parameters.isNotEmpty) {
            params = jsonDecode(step.parameters);
          }
        } catch (e) {
          print('Error decoding parameters for step ${step.id}: $e');
          // Handle error, maybe show default text or an error indicator
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(child: Text('${step.order}')),
            title: Text('Type: ${step.type}'),
            subtitle: Text(
              'Parameters: ${params.isEmpty ? 'None' : params.toString()}',
            ),
            // Add more details or icons based on step.type if needed
          ),
        );
      },
    );
  }
}
