import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/actions/actions_screen.dart';
import '../features/actions/action_detail_screen.dart'; // Will create this next
import '../screens/home_screen.dart';

// Define route paths
class AppRoutePaths {
  static const String home = '/';
  static const String actions = '/actions';
  static const String actionDetail = 'action/:actionId'; // Parameterized route
}

// Define route names (optional but good practice)
class AppRouteNames {
  static const String home = 'home';
  static const String actions = 'actions';
  static const String actionDetail = 'actionDetail';
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
    // TODO: Add routes for Profile, Settings etc. if needed as separate screens
  ],
  // TODO: Add error handling (e.g., errorBuilder for 404s)
);
