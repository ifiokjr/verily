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

  // Method to show the Add/Edit Step Dialog
  Future<void> _showAddEditStepDialog({protocol.ActionStep? step}) async {
    // Show the dialog and wait for it to potentially return a boolean (true if saved)
    final bool? didSave = await showDialog<bool>(
      context: context,
      builder:
          (context) => AddEditStepDialog(
            actionId: widget.actionId,
            existingStep: step, // Pass existing step for editing
          ),
    );

    // If the dialog indicated a save occurred, refresh the action details
    if (didSave == true) {
      ref.invalidate(actionDetailsProvider(widget.actionId));
      // Optionally show a success message (though dialog might handle it)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(step == null ? 'Step added!' : 'Step updated!')),
      // );
    }
  }

  // Method to handle deleting a step
  Future<void> _deleteStep(protocol.ActionStep step) async {
    // Confirm deletion
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Step?'),
            content: Text(
              'Are you sure you want to delete Step ${step.order} (${step.type})? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmDelete == true && step.id != null) {
      try {
        // TODO: Add loading indicator during deletion
        final success = await client.action.deleteActionStep(step.id!);
        if (success) {
          ref.invalidate(actionDetailsProvider(widget.actionId));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Step ${step.order} deleted.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Failed to delete step. Action not found or not owner?',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } catch (e) {
        print('Error deleting step ${step.id}: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting step: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

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
              onPressed:
                  () =>
                      _showAddEditStepDialog(), // Call without step for adding
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                          tooltip: 'Edit Step ${step.order}',
                          onPressed:
                              () => _showAddEditStepDialog(
                                step: step,
                              ), // Call WITH step for editing
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          tooltip: 'Delete Step ${step.order}',
                          onPressed:
                              () => _deleteStep(step), // Call delete method
                        ),
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
