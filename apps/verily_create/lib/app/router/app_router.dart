import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:verily_create/features/action_creation/presentation/pages/action_list_page.dart';
import 'package:verily_create/features/action_creation/presentation/pages/create_action_page.dart';
import 'package:verily_create/features/action_creation/presentation/pages/edit_action_page.dart';
import 'package:verily_create/features/auth/presentation/pages/sign_in_page.dart';
import 'package:verily_create/main.dart';

/// Provider for the app's router
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

/// Central routing configuration for the app
class AppRouter {
  /// The GoRouter instance with all route definitions
  static final router = GoRouter(
    initialLocation: '/actions',
    debugLogDiagnostics: true,

    // Redirect to sign-in if not authenticated
    redirect: (context, state) {
      final isSignedIn = sessionManager.isSignedIn;
      if (!isSignedIn && !state.fullPath!.startsWith('/auth')) {
        return '/auth/signin';
      }
      return null;
    },

    routes: [
      // Authentication Routes
      GoRoute(
        path: '/auth/signin',
        name: 'signin',
        builder: (context, state) => const SignInPage(),
      ),

      // Actions List (Main Route)
      GoRoute(
        path: '/actions',
        name: 'actions',
        builder: (context, state) => const ActionListPage(),
      ),

      // Create New Action
      GoRoute(
        path: '/actions/new',
        name: 'create-action',
        builder: (context, state) => const CreateActionPage(),
      ),

      // Edit Existing Action
      GoRoute(
        path: '/actions/:actionId/edit',
        name: 'edit-action',
        builder: (context, state) {
          final actionId = int.parse(state.pathParameters['actionId']!);
          return EditActionPage(actionId: actionId);
        },
      ),
    ],

    // Error route for invalid paths
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Route not found: ${state.uri.path}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/actions'),
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
