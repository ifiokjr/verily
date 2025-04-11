import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_create/features/action_creation/presentation/pages/create_action_page.dart'; // Placeholder for navigation
// Import generated client with a prefix to avoid name collision
import 'package:verily_client/verily_client.dart' as protocol;
import 'package:verily_create/main.dart'; // Import main to access client instance

// Provider to fetch the user's actions
// Using FutureProvider for simple one-time fetch
final myActionsProvider = FutureProvider<List<protocol.Action>>((ref) async {
  try {
    // Access the globally initialized client
    return await client.action.getMyActions();
  } catch (e) {
    // Log error or handle appropriately
    print('Error fetching actions: $e');
    rethrow; // Rethrow to let the provider handle the error state
  }
});

/// A page to display a list of created actions and allow creation of new ones.
class ActionListPage extends ConsumerWidget {
  const ActionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the async state
    final actionsAsyncValue = ref.watch(myActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verily Actions'),
        // Applying Apple Human Interface Guidelines: Clean title, potential actions top right.
        centerTitle: false, // Typically left-aligned on wider screens
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create New Action',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateActionPage(),
                ), // Navigate to creation page
              );
            },
          ),
        ],
      ),
      body: Center(
        // Applying Apple HIG: Use appropriate padding and potentially a List view.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: actionsAsyncValue.when(
            data:
                (actions) =>
                    actions.isEmpty
                        ? _buildEmptyState(context)
                        : _buildActionList(actions),
            loading: () => const CircularProgressIndicator(),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    'Error fetching actions: $error\n\nTry refreshing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    // Applying Apple HIG: Clear, concise text, and a primary call to action.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.playlist_add_check, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          'No Actions Yet',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Ready to add some verifiable magic? \nCreate your first action!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Create First Action'),
          // Applying Apple HIG: Prominent button style for primary action.
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateActionPage(),
              ), // Navigate to creation page
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionList(List<protocol.Action> actions) {
    // Applying Apple HIG: Use ListView for scrollable content.
    // Use ListTile for structured row items.
    return ListView.builder(
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          // Add some elevation and margin for separation
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          elevation: 1.0,
          child: ListTile(
            // Applying Apple HIG: Leading icon, clear title/subtitle.
            leading: const Icon(Icons.checklist_rtl_outlined, size: 30),
            title: Text(
              action.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              action.description ?? 'No description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right), // Indicate tappable
            onTap: () {
              // TODO: Implement navigation to Action Detail/Edit page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on Action: ${action.name}')),
              );
            },
          ),
        );
      },
    );
  }
}
