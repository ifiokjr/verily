import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:verily_create/main.dart'; // To access sessionManager

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Dialog(
          // Applying Apple HIG: Present auth modally, often in a card-like dialog.
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign In / Sign Up',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Pre-built Serverpod Sign in with Email button
                SignInWithEmailButton(
                  caller:
                      client.modules.auth, // Correct: Use the base auth caller
                  onSignedIn: () {
                    // Pop the dialog on successful sign-in
                    print('Email Sign in successful!');
                    // Optionally navigate away or rely on the main listener
                    // if (Navigator.canPop(context)) {
                    //   Navigator.of(context).pop();
                    // }
                  },
                  // onFailure is not a parameter for this widget.
                  // Error handling is often managed by Serverpod's state or exceptions.
                  // Applying Apple HIG: Style button appropriately for context.
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // TODO: Add other sign-in methods if needed (Google, Apple)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
