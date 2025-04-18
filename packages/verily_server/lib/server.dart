import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

import 'package:verily_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// Import the new endpoint

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Configure Auth module
  auth.AuthConfig.set(
    auth.AuthConfig(
      // Callback for sending validation email
      sendValidationEmail: (session, email, validationCode) async {
        // Log the validation code to the console for debugging/testing
        print('--- Email Validation Code for $email: $validationCode ---');
        // In production, replace the print statement with actual email sending logic.
        // Example using a hypothetical email service:
        // final success = await EmailService.sendValidation(to: email, code: validationCode);
        // return success;
        return true; // Assume sending is successful for now
      },
      // Callback for sending password reset email
      sendPasswordResetEmail: (session, userInfo, validationCode) async {
        // Log the reset code to the console for debugging/testing
        print(
          '--- Password Reset Code for ${userInfo.email ?? userInfo.userName}: $validationCode ---',
        );
        // In production, replace the print statement with actual email sending logic.
        // final success = await EmailService.sendPasswordReset(to: userInfo.email!, code: validationCode);
        // return success;
        return true; // Assume sending is successful for now
      },
      // Optional: Add other configurations like minimum password length
      // minPasswordLength: 10,
    ),
  );

  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  // Start the server.
  await pod.start();
}
