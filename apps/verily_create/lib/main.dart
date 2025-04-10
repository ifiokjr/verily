import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_create/features/action_creation/presentation/pages/action_list_page.dart';

// TODO: Initialize Serverpod client
// import 'package:verily_client/verily_client.dart';
// import 'package:serverpod_flutter/serverpod_flutter.dart';

// var client = Client('http://localhost:8080/')..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  // TODO: Initialize Serverpod client before running the app
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verily Creator',
      theme: ThemeData(
        // Applying Apple HIG: Use system font, consider Cupertino theme elements
        primarySwatch: Colors.blue,
        // Use Material 3 for a more modern look, closer to current UI trends
        useMaterial3: true,
        // Visual density helps adapt layout to different screen sizes
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define text themes consistent with platform standards
        textTheme: const TextTheme(
          // Example: Use standard body text style
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
        // Define button styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ), // Slightly rounded corners are common
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        appBarTheme: const AppBarTheme(
          // Minimal elevation for a flatter, modern look
          elevation: 0,
          centerTitle: false,
          // Use a slightly lighter color for the app bar for subtle contrast
          // backgroundColor: Colors.grey[50], // Example light background
          // foregroundColor: Colors.black87, // Ensure text/icons are readable
        ),
      ),
      home: const ActionListPage(), // Set the home page
      debugShowCheckedModeBanner: false,
    );
  }
}
