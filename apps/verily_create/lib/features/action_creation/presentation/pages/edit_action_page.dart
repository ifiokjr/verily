import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:verily_client/verily_client.dart' as protocol; // Use prefix
import 'package:verily_create/main.dart'; // Import client
import 'package:verily_create/features/action_creation/presentation/widgets/add_edit_step_dialog.dart'; // Import the dialog

// Provider to fetch details for a specific action
// Using family modifier to pass the actionId
final actionDetailsProvider = FutureProvider.family<protocol.Action?, int>((
  ref,
  actionId,
) async {
  try {
    // Access the globally initialized client
    return await client.action.getActionDetails(actionId);
  } catch (e) {
    print('Error fetching action details for $actionId: $e');
    rethrow; // Let the provider handle the error state
  }
});

/// A page for viewing and editing an existing Verily Action and its steps.
class EditActionPage extends ConsumerStatefulWidget {
  final int actionId;
  const EditActionPage({required this.actionId, super.key});

  @override
  ConsumerState<EditActionPage> createState() => _EditActionPageState();
}

class _EditActionPageState extends ConsumerState<EditActionPage> {
  // TODO: Add form controllers and state for editing action details
  // TODO: Add state management for action steps list

  @override
  Widget build(BuildContext context) {
    final actionDetailsAsync = ref.watch(
      actionDetailsProvider(widget.actionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: actionDetailsAsync.when(
          data: (action) => Text(action?.name ?? 'Edit Action'),
          loading: () => const Text('Loading Action...'),
          error: (_, __) => const Text('Error Loading Action'),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/actions'),
        ),
        // TODO: Add Save/Update action button?
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: actionDetailsAsync.when(
            data: (action) {
              if (action == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Action not found or access denied.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/actions'),
                        child: const Text('Return to Action List'),
                      ),
                    ],
                  ),
                );
              }
              // Pass action to the build method
              return _buildEditForm(context, action);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error fetching action details: $error',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/actions'),
                        child: const Text('Return to Action List'),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, protocol.Action action) {
    // Get the steps list from the fetched action
    final steps = action.steps ?? [];

    // Method to show the Add/Edit Step Dialog
    Future<void> _showAddEditStepDialog({protocol.ActionStep? step}) async {
      await showDialog<bool>(
        context: context,
        builder: (context) => AddEditStepDialog(actionId: widget.actionId),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Action Details (Display Only for now) ---
        Text('Action Details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Name: ${action.name}'),
        const SizedBox(height: 8),
        Text('Description: ${action.description ?? 'N/A'}'),
        const SizedBox(height: 8),
        Text('Location ID: ${action.locationId?.toString() ?? 'Not Set'}'),
        const SizedBox(height: 8),
        Text(
          'Valid From: ${action.validFrom?.toLocal().toString() ?? 'Not Set'}',
        ),
        const SizedBox(height: 8),
        Text(
          'Valid Until: ${action.validUntil?.toLocal().toString() ?? 'Not Set'}',
        ),
        const SizedBox(height: 8),
        Text(
          'Max Time (sec): ${action.maxCompletionTimeSeconds?.toString() ?? 'Not Set'}',
        ),
        const SizedBox(height: 8),
        Text('Strict Order: ${action.strictOrder}'),
        const Divider(height: 32),

        // --- Action Steps Section ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Steps', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add Step',
              onPressed: () => _showAddEditStepDialog(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Display Existing Steps or Empty State
        steps.isEmpty
            ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: const Center(
                child: Text(
                  'No steps added yet. Click + to add one.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
            : ListView.builder(
              shrinkWrap: true, // Important for ListView inside Column
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling for inner list
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${step.order}')),
                    title: Text('Type: ${step.type}'),
                    subtitle: Text('Params: ${step.parameters}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Edit Step ${step.order} clicked!',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Delete Step ${step.order} clicked!',
                                ),
                              ),
                            );
                          },
                        ),
                        // TODO: Add Reorder handle if using ReorderableListView
                      ],
                    ),
                  ),
                );
              },
            ),

        // TODO: Add Webhook Management section
      ],
    );
  }
}
