import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:verily/src/features/actions/action_detail_screen.dart';
import 'package:verily/src/features/actions/actions_screen.dart'; // Assuming you have this screen
import 'package:verily/src/features/profile/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:verily/src/features/settings/screens/settings_screen.dart'; // Import SettingsScreen
import 'package:verily/src/features/verification/screens/verification_screen.dart';
import 'package:verily/src/screens/home_screen.dart'; // Assuming the main screen is HomeScreen

// --- Route Names ---
// Using a class for route names helps with organization and avoids typos.
class AppRoute {
  static const home = 'home'; // Corresponds to '/' path
  static const actions = 'actions'; // Corresponds to '/actions'
  static const actionDetail =
      'actionDetail'; // Corresponds to '/actions/:actionId'
  static const verify = 'verify'; // Corresponds to '/verify/:actionId'
  static const profile = 'profile'; // Corresponds to '/profile'
  static const settings = 'settings'; // Corresponds to '/settings'
}

// --- Riverpod Provider for GoRouter ---
// Provides the GoRouter instance throughout the app.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/', // Start at the root/home path
    debugLogDiagnostics: true, // Log navigation events in debug mode
    routes: [
      // --- Home Route and Nested Action Routes ---
      // The main entry point of the app, potentially containing nested navigation.
      GoRoute(
        path: '/',
        name: AppRoute.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Actions list (e.g., if shown within a tab or section of HomeScreen)
          GoRoute(
            path: 'actions', // Relative path: '/actions'
            name: AppRoute.actions,
            builder: (context, state) => const ActionsScreen(),
            routes: [
              // Action Detail
              GoRoute(
                path: ':actionId', // Relative path: '/actions/:actionId'
                name: AppRoute.actionDetail,
                builder: (context, state) {
                  final actionIdString = state.pathParameters['actionId'];
                  final actionId = int.tryParse(actionIdString ?? '');
                  if (actionId == null) {
                    return const Scaffold(
                      body: Center(child: Text('Invalid Action ID')),
                    );
                  }
                  return ActionDetailScreen(actionId: actionId);
                },
              ),
            ],
          ),
        ],
      ),
      // --- Verification Route (Top-Level for Deep Linking) ---
      // Handles verily://verify/:actionId deep links.
      GoRoute(
        path: '/verify/:actionId',
        name: AppRoute.verify,
        builder: (context, state) {
          final actionIdString = state.pathParameters['actionId'];
          final actionId = int.tryParse(actionIdString ?? '');
          if (actionId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid Action ID for Verification')),
            );
          }
          // VerificationScreen needs to be updated to accept actionId
          return VerificationScreen(actionId: actionId);
        },
      ),
      // --- Profile Route ---
      GoRoute(
        path: '/profile',
        name: AppRoute.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      // --- Settings Route ---
      GoRoute(
        path: '/settings',
        name: AppRoute.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    // --- Error Handling ---
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(child: Text('Error: ${state.error?.message}')),
        ),
  );
});
