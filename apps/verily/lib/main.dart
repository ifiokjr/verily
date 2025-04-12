import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/screens/home_screen.dart'; // Import HomeScreen
import 'src/routing/app_router.dart'; // Import the router config

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Wrap the entire app in a ProviderScope to enable Riverpod state management.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Use MaterialApp.router to integrate GoRouter
    return MaterialApp.router(
      routerConfig: goRouter, // Provide the router configuration
      title: 'Verily', // Changed title
      theme: ThemeData(
        // Using a more modern theme approach with colorScheme
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true, // Enable Material 3 design
        // Apply consistent theme for AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0, // Flat AppBar
        ),
        // Apply consistent theme for BottomNavigationBar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      // 'home' is not used with MaterialApp.router
      // home: const HomeScreen(),
    );
  }
}
