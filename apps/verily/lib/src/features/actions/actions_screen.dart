import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/action_providers.dart';
import 'widgets/action_list_view.dart';

/// Screen to display available, accepted, and local actions.
class ActionsScreen extends ConsumerWidget {
  const ActionsScreen({super.key});

  static const List<Tab> _tabs = <Tab>[
    Tab(text: 'Available'),
    Tab(text: 'Accepted'),
    Tab(text: 'Local'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using DefaultTabController to manage the tab state.
    // It's often simpler for basic tab structures.
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actions'),
          // Place the TabBar in the bottom of the AppBar
          // for a common mobile pattern.
          bottom: const TabBar(tabs: _tabs),
        ),
        // TabBarView contains the content for each tab.
        body: TabBarView(
          children: [
            // Each child corresponds to a tab in the TabBar.
            // Use the ActionListView widget, passing the appropriate provider.
            ActionListView(provider: availableActionsProvider),
            ActionListView(provider: acceptedActionsProvider),
            ActionListView(provider: localActionsProvider),
          ],
        ),
      ),
    );
  }
}
