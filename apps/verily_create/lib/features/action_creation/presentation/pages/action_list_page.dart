import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_create/features/action_creation/presentation/pages/create_action_page.dart'; // Placeholder for navigation

/// A page to display a list of created actions and allow creation of new ones.
class ActionListPage extends ConsumerWidget {
  const ActionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch and display list of actions using Riverpod provider
    final actions = []; // Placeholder

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
          child:
              actions.isEmpty
                  ? _buildEmptyState(context)
                  : _buildActionList(actions), // Placeholder for list view
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

  Widget _buildActionList(List actions) {
    // TODO: Implement ListView to display actions
    return const Center(child: Text('Action list will be displayed here.'));
  }
}
