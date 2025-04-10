import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:verily_create/main.dart'; // To access client

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle background color
      body: Center(
        // Constrain the width for better web layout
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            // Use a Card for elevation and clear boundaries
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome to Verily Creator',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in or create an account to manage your actions.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SignInWithEmailButton(
                    caller: client.modules.auth, // Base auth caller
                    onSignedIn: () {
                      print('Email Sign in/up successful!');
                      // Navigation handled by the main listener on sessionManager
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Optional: Add divider or text for other methods
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider()),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: Text('OR', style: TextStyle(color: Colors.grey)),
                  //     ),
                  //     Expanded(child: Divider()),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                  // TODO: Add other sign-in buttons (Google, Apple) here if needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
