import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/actions/actions_screen.dart';
import '../features/actions/action_detail_screen.dart'; // Will create this next
import '../features/verification/screens/verification_screen.dart'; // Import VerificationScreen
import '../screens/home_screen.dart';

// Define route paths
class AppRoutePaths {
  static const String home = '/';
  static const String actions = '/actions';
  static const String actionDetail = 'action/:actionId'; // Parameterized route
  static const String verifyAction =
      '/verify/:actionId'; // New route for verification
}

// Define route names (optional but good practice)
class AppRouteNames {
  static const String home = 'home';
  static const String actions = 'actions';
  static const String actionDetail = 'actionDetail';
  static const String verifyAction = 'verifyAction'; // New route name
}

/// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: AppRoutePaths.home,
  debugLogDiagnostics: true, // Log navigation events in debug mode
  routes: [
    // Main application shell (BottomNavigationBar)
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.home,
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Nested route for actions, displayed within HomeScreen's structure
        // Note: ActionsScreen itself has the TabBar, so we just need the base route.
        // For detail screen, we navigate away from the main shell temporarily.
      ],
    ),
    // Separate route for Action Detail screen (pushes on top of HomeScreen)
    GoRoute(
      path: '${AppRoutePaths.actions}/${AppRoutePaths.actionDetail}',
      name: AppRouteNames.actionDetail,
      builder: (context, state) {
        // Extract actionId from the path parameters
        final actionIdString = state.pathParameters['actionId'];
        // TODO: Add robust error handling if actionId is null or not an int
        final actionId = int.tryParse(actionIdString ?? '') ?? -1;
        return ActionDetailScreen(actionId: actionId);
      },
    ),
    // Verification Flow screen
    GoRoute(
      path: AppRoutePaths.verifyAction, // Use the new path
      name: AppRouteNames.verifyAction, // Use the new name
      builder: (context, state) {
        final actionIdString = state.pathParameters['actionId'];
        final actionId = int.tryParse(actionIdString ?? '') ?? -1;
        // Note: VerificationScreen doesn't strictly need the ID if it relies
        // solely on the provider state, which is initiated by startFlow.
        // However, passing it might be useful for context or direct fetching if needed.
        return const VerificationScreen();
      },
    ),
    // TODO: Add routes for Profile, Settings etc. if needed as separate screens
  ],
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text('Error: ${state.error?.message}')),
      ),
);
