import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Unused import

// Correct import path assuming standard features structure
import '../features/actions/actions_screen.dart';

/// The main screen of the app, managing navigation between features.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets to display based on the selected index.
  // Removed 'const' because ActionsScreen() is not a constant.
  static final List<Widget> _widgetOptions = <Widget>[
    const ActionsScreen(), // Can be const if ActionsScreen is const
    const Text('Profile (Placeholder)'), // Placeholder for the second tab
    const Text('Settings (Placeholder)'), // Placeholder for the third tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the widget corresponding to the selected tab.
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
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
        currentIndex: _selectedIndex,
        selectedItemColor:
            Theme.of(context).colorScheme.primary, // Use theme color
        // Ensure type is set for better animation/layout on more than 3 items
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
