import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_create/features/action_creation/presentation/pages/action_list_page.dart';
import 'package:verily_client/verily_client.dart'; // Import generated client
import 'package:serverpod_flutter/serverpod_flutter.dart';
// Import for SessionManager
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart'; // Import for FlutterAuthenticationKeyManager
import 'package:verily_create/features/auth/presentation/pages/sign_in_page.dart';
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
    // Listen to the session manager
    // Note: You might want a dedicated provider for this later
    final isSignedIn = sessionManager.isSignedIn;

    // Add listener to rebuild when auth state changes
    // This is a basic way; consider using a StreamProvider or StateNotifierProvider
    // listening to sessionManager for better state management.
    sessionManager.addListener(() {
      // This forces a rebuild, but isn't the most efficient Riverpod way.
      // Consider using a provider that watches sessionManager.
      (context as Element).markNeedsBuild();
    });

    return MaterialApp(
      title: 'Verily Creator',
      theme: AppTheme.lightTheme, // Use light theme
      darkTheme: AppTheme.darkTheme, // Use dark theme
      themeMode: ThemeMode.system, // Follow system preference
      home: isSignedIn ? const ActionListPage() : const SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
