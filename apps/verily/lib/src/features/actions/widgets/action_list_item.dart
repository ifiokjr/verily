import 'package:flutter/material.dart';
import 'package:verily_client/verily_client.dart' as vc; // Use prefix

/// A placeholder widget to display a single action item in a list.
class ActionListItem extends StatelessWidget {
  /// The action data to display.
  final vc.Action action; // Use prefixed type

  const ActionListItem({required this.action, super.key});

  @override
  Widget build(BuildContext context) {
    // Get the theme for consistent styling.
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Use a ListTile for standard list item structure.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        // Display the action name as the title.
        // Using titleLarge style as per guidelines.
        title: Text(action.name, style: textTheme.titleLarge),
        // Display the action description as the subtitle.
        subtitle: Text(action.description ?? 'No description'),
        // Add a trailing icon to indicate it's tappable (optional).
        trailing: const Icon(Icons.chevron_right),
        // Define the action to take when the item is tapped.
        onTap: () {
          // TODO: Implement navigation to action details screen.
          // Example: context.go('/actions/${action.id}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on action: ${action.name}')),
          );
        },
      ),
    );
  }
}
