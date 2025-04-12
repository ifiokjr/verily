import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart'; // Import generated client
import 'package:serverpod_flutter/serverpod_flutter.dart';
// Import for SessionManager
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart'; // Import for FlutterAuthenticationKeyManager
import 'package:verily_create/app/router/app_router.dart'; // Import router configuration
import 'package:verily_ui/verily_ui.dart'; // Import the UI package

// TODO: Initialize Serverpod client
// import 'package:verily_client/verily_client.dart';
// import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
// TODO: Make the server URL configurable (e.g., via environment variables)
var client = Client(
  'http://localhost:8080/', // Default local development URL
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
)..connectivityMonitor = FlutterConnectivityMonitor();

// The session manager keeps track of the signed-in state of the user.
late SessionManager sessionManager;

/// Provider to expose authentication state
final authStateProvider = StateProvider<bool>((ref) {
  return sessionManager.isSignedIn;
});

Future<void> main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the session manager.
  sessionManager = SessionManager(
    caller: client.modules.auth, // Access the generated auth module client
  );
  await sessionManager.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the router from the provider
    final router = ref.watch(appRouterProvider);

    // Track auth state changes
    final isSignedIn = sessionManager.isSignedIn;
    ref.read(authStateProvider.notifier).state = isSignedIn;

    // Listen for auth changes
    sessionManager.addListener(() {
      // Update auth state provider when session changes
      ref.read(authStateProvider.notifier).state = sessionManager.isSignedIn;
    });

    return MaterialApp.router(
      title: 'Verily Creator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
