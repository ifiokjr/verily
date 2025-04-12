import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:verily_client/verily_client.dart' as vc; // Use prefix

// Corrected import path for router
import '../../../routing/app_router.dart';

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
          // Navigate to the ActionDetailScreen using GoRouter
          // Ensure action.id is not null before navigating
          if (action.id != null) {
            // Use pushNamed for detail screens to add to stack
            context.pushNamed(
              AppRoute
                  .actionDetail, // Use the corrected route name from AppRoute
              pathParameters: {'actionId': action.id.toString()}, // Pass ID
            );
          } else {
            // Handle cases where action.id might be null (optional)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Action ID is missing.')),
            );
          }
        },
      ),
    );
  }
}
