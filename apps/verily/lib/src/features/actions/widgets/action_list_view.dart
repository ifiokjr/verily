import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as vc; // Use prefix

import 'action_list_item.dart';

/// A reusable widget to display a list of actions fetched from a provider.
class ActionListView extends ConsumerWidget {
  /// The provider that fetches the list of actions.
  final Provider<List<vc.Action>> provider;

  const ActionListView({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the list directly
    final actions = ref.watch(provider);

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
  }
}
