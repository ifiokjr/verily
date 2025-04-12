import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/routing/app_router.dart'; // Import the router config
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove();

  // Wrap the entire app in a ProviderScope to enable Riverpod state management.
  runApp(const ProviderScope(child: MyApp()));
}

// Use ConsumerWidget to access the GoRouter provider
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the router configuration from the provider
    final router = ref.watch(goRouterProvider);

    // Use MaterialApp.router to integrate GoRouter
    return MaterialApp.router(
      routerConfig:
          router, // Provide the router configuration from the provider
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
          unselectedItemColor: Theme.of(context).colorScheme.onSurface
              .withAlpha(153), // Equivalent to opacity 0.6 (0.6 * 255 = 153)
        ),
      ),
      // 'home' is not used with MaterialApp.router
      // home: const HomeScreen(),
    );
  }
}
