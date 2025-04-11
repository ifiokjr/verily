import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart'; // Assuming Action is here

import 'action_list_item.dart';

/// A reusable widget to display a list of actions fetched from a provider.
class ActionListView extends ConsumerWidget {
  /// The provider that fetches the list of actions.
  final AutoDisposeFutureProvider<List<Action>> provider;

  const ActionListView({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the async state.
    final actionsAsync = ref.watch(provider);

    // Handle loading, error, and data states.
    return actionsAsync.when(
      // Display a loading indicator while fetching.
      loading: () => const Center(child: CircularProgressIndicator()),
      // Display an error message if fetching fails.
      // Using SelectableText.rich for better error visibility, following guidelines.
      error:
          (err, stack) => Center(
            child: SelectableText.rich(
              TextSpan(
                text: 'Error loading actions: ',
                children: [
                  TextSpan(
                    text: err.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
      // Build the list view when data is available.
      data: (actions) {
        // Handle the case where the list is empty.
        if (actions.isEmpty) {
          return const Center(child: Text('No actions found.'));
        }
        // Use ListView.builder for efficient list rendering.
        return ListView.builder(
          itemCount: actions.length,
          itemBuilder: (context, index) {
            // Get the specific action for the current item.
            final action = actions[index];
            // Render each action using the ActionListItem widget.
            return ActionListItem(action: action);
          },
        );
      },
    );
  }
}
