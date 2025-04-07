import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/instructions_screen.dart';

// Navigator key
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// App routes
enum AppRoute {
  home,
  instructions,
  game,
}

// Provider for GoRouter configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/', // Start at home
    debugLogDiagnostics: true, // Log navigation changes
    routes: [
      // Home Screen
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      // Instructions Screen
      GoRoute(
        path: '/instructions',
        name: AppRoute.instructions.name,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: InstructionsScreen(),
        ),
      ),
      // Game Screen
      GoRoute(
        path: '/game',
        name: AppRoute.game.name,
        builder: (context, state) => const GameScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.error}')),
    ), // Basic error page
  );
});
