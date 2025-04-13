import 'package:flutter/foundation.dart'; // Import ChangeNotifier
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

/// ChangeNotifier that notifies listeners about auth state changes.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    sessionManager.addListener(_onAuthStateChanged);
  }

  bool _isSignedIn = sessionManager.isSignedIn;
  bool get isSignedIn => _isSignedIn;

  void _onAuthStateChanged() {
    final newState = sessionManager.isSignedIn;
    if (_isSignedIn != newState) {
      _isSignedIn = newState;
      notifyListeners(); // Notify GoRouter and other listeners
    }
  }

  @override
  void dispose() {
    sessionManager.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}

/// Provider for the AuthNotifier
final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  // Ensure sessionManager is initialized before creating AuthNotifier
  // This assumes sessionManager initialization in main() happens first.
  return AuthNotifier();
});

/// Provider to expose authentication state (can still be useful for direct UI checks)
/// Now listens to AuthNotifier for changes.
final authStateProvider = StateProvider<bool>((ref) {
  // Listen to the AuthNotifier
  final authNotifier = ref.watch(authNotifierProvider);
  return authNotifier.isSignedIn;
});

Future<void> main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the session manager.
  sessionManager = SessionManager(
    caller: client.modules.auth, // Access the generated auth module client
  );
  await sessionManager.initialize();

  // Create the AuthNotifier instance *after* sessionManager is initialized
  // final authNotifier = AuthNotifier(); // No longer needed here, handled by provider

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the AuthNotifier provider so the listener is attached.
    ref.watch(authNotifierProvider);

    // Get the router from the provider
    final router = ref.watch(appRouterProvider);

    // Track auth state changes - No longer needed here, handled by authNotifierProvider/authStateProvider
    // final isSignedIn = sessionManager.isSignedIn;
    // ref.read(authStateProvider.notifier).state = isSignedIn;

    // Listen for auth changes - No longer needed here, handled by AuthNotifier
    // sessionManager.addListener(() {
    //   // Update auth state provider when session changes
    //   ref.read(authStateProvider.notifier).state = sessionManager.isSignedIn;
    // });

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
