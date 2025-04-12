import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Unused import

// Correct import path assuming standard features structure
import '../features/actions/actions_screen.dart';

/// The main screen of the app, managing navigation between features.
/// Refactored to use Hooks for managing the selected tab index.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  // List of widgets to display based on the selected index.
  // Keep static if ActionsScreen can be const, otherwise make non-static.
  static final List<Widget> _widgetOptions = <Widget>[
    const ActionsScreen(), // Assumes ActionsScreen is const
    const Text('Profile (Placeholder)'), // Placeholder for the second tab
    const Text('Settings (Placeholder)'), // Placeholder for the third tab
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the useState hook to manage the selected index.
    // Initial value is 0.
    final selectedIndex = useState(0);

    // Callback function to update the index when a tab is tapped.
    void onItemTapped(int index) {
      selectedIndex.value = index;
    }

    return Scaffold(
      // The body displays the widget corresponding to the selected tab.
      body: Center(
        // Access the current index via selectedIndex.value
        child: _widgetOptions.elementAt(selectedIndex.value),
      ),
      // Define the BottomNavigationBar.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Actions'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        // Use selectedIndex.value for the current index.
        currentIndex: selectedIndex.value,
        selectedItemColor:
            Theme.of(context).colorScheme.primary, // Use theme color
        // Ensure type is set for better animation/layout on more than 3 items
        type: BottomNavigationBarType.fixed,
        // Pass the callback function.
        onTap: onItemTapped,
      ),
    );
  }
}
