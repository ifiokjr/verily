# Device Attestation in Flutter

Okay, let's break down how you can implement device attestation in a Flutter app.

Remember, device attestation is fundamentally about **verifying** the integrity of the device and your app instance **on your backend server**. The Flutter app's role is primarily to _request_ an attestation token/assertion from the underlying OS (Android/iOS) and send it to your server. The _real_ verification happens server-side using Google/Apple APIs.

Since Flutter targets both Android and iOS, you'll need to handle the platform-specific APIs:

1. **Android:** **Play Integrity API** (This is the modern API, replacing the older SafetyNet Attestation).
2. **iOS:** **App Attest** (part of the DeviceCheck framework).

**Implementation Strategy in Flutter**

You generally have two approaches:

1. **Use Existing Plugins:** This is the recommended approach. Community or official plugins wrap the native Android/iOS SDKs, providing a Dart API you can call from your Flutter code. This abstracts away much of the platform-specific complexity.
2. **Write Platform Channels:** If no suitable plugin exists or you need very specific control, you can write your own platform channels to call the native Android (Kotlin/Java) and iOS (Swift/Objective-C) device attestation APIs directly. This requires native development knowledge.

We'll focus on using plugins, as it's more common and practical for most Flutter developers.

**Steps for Implementation (Using Plugins)**

Here’s a conceptual guide. The exact code will depend on the specific plugin(s) you choose.

**1. Find and Choose Plugins**

- Search on [pub.dev](https://pub.dev/) for plugins related to:
  - `play integrity` (for Android)
  - `app attest` or `device check` (for iOS)
- Look for well-maintained plugins with good documentation and community support. Examples might include (check pub.dev for the latest and best options):
  - `play_integrity_flutter` (community plugin for Android's Play Integrity)
  - `flutter_app_attest` (community plugin for iOS App Attest)
  - Potentially separate plugins or a single plugin attempting to abstract both (though this can be tricky due to API differences).

**2. Add Plugins to `pubspec.yaml`**

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Example plugins (replace with your chosen ones)
  play_integrity_flutter: ^latest_version
  flutter_app_attest: ^latest_version
  # Other dependencies...
```

Run `flutter pub get`.

**3. Platform-Specific Setup (Crucial!)**

This step involves configuring your app with Google and Apple services.

- **Android (Play Integrity API):**
  - **Google Play Console:** Ensure your app is registered. You might need to link your Google Cloud Project.
  - **Google Cloud Console:** Enable the "Android Device Verification API". Standard Play Integrity usage often doesn't require explicit Cloud setup _unless_ you make classic requests or significantly exceed free quotas, but it's good practice to have a Cloud project linked.
  - **App Configuration:** The plugin might require specific configurations in your `android/app/build.gradle` or `AndroidManifest.xml`, though often it handles this automatically. Follow the plugin's documentation carefully.

- **iOS (App Attest):**
  - **Apple Developer Portal:**
    - Ensure your App ID has the "App Attest" capability enabled.
    - Generate provisioning profiles that include this capability.
  - **Xcode:**
    - Open the `ios` folder of your Flutter project in Xcode.
    - Go to "Signing & Capabilities".
    - Click "+ Capability" and add "App Attest".
  - **App Configuration:** Ensure your `Info.plist` is set up correctly (usually handled by Xcode capabilities).

**4. Implement Flutter Code (Client-Side)**

- **Import:** Import the necessary Dart files from your chosen plugin(s).
- **Generate a Nonce (Important!):** To prevent replay attacks, your **backend server** should generate a unique, time-limited random string (nonce) for each attestation request. Your app requests this nonce _before_ asking for the attestation token.
- **Request Attestation Token:**
  - Use conditional logic (`Platform.isAndroid` / `Platform.isIOS`) or the plugin's abstraction (if it provides one) to call the correct attestation method.
  - **Android (Play Integrity):**
    - You'll likely call a function like `requestIntegrityToken`.
    - You **must** provide the `nonce` received from your server to the Play Integrity request. Google includes this nonce in the signed token.
    - Some plugins might also require your Google Cloud Project number for certain types of requests (check plugin docs).
  - **iOS (App Attest):**
    - You'll likely call a function like `generateKey` (one-time setup) and then `attestKey` or `generateAssertion`.
    - You need to provide a `challenge` (which is your `nonce` from the server) hashed with SHA256. The plugin might handle the hashing, or you might need to do it in Dart using `crypto` or similar packages.
- **Handle the Response:**
  - The plugin will return the attestation token (Android) or assertion (iOS) upon success.
  - Implement robust error handling (network errors, API not available, feature limited, setup errors, etc.).
- **Send to Backend:** Send the received token/assertion **along with the original nonce** to your backend server for verification.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For PlatformException
import 'dart:io' show Platform;
// Example imports - replace with your actual plugins
import 'package:play_integrity_flutter/play_integrity_flutter.dart';
import 'package:flutter_app_attest/flutter_app_attest.dart';
import 'package:http/http.dart' as http; // For backend communication
import 'dart:convert'; // For hashing/encoding
import 'package:crypto/crypto.dart'; // For SHA256 on iOS challenge

class AttestationService {

  // --- Placeholder for your backend communication ---
  Future<String?> _getNonceFromServer() async {
    // TODO: Implement call to your backend to get a unique nonce
    print("Requesting nonce from server...");
    await Future.delayed(Duration(milliseconds: 100)); // Simulate network
    return "server_generated_unique_nonce_${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<bool> _verifyTokenOnServer(String tokenOrAssertion, String nonce) async {
     // TODO: Implement call to your backend, sending the token/assertion and nonce
     print("Sending token/assertion and nonce to server for verification...");
     print("Nonce: $nonce");
     print("Token/Assertion: $tokenOrAssertion");
     await Future.delayed(Duration(milliseconds: 200)); // Simulate network
     // Assume server responds with true if valid, false otherwise
     return true;
  }
  // --- End Placeholder ---


  Future<bool> attestDevice() async {
    String? nonce = await _getNonceFromServer();
    if (nonce == null) {
      print("Failed to get nonce from server.");
      return false;
    }

    String? attestationData;

    try {
      if (Platform.isAndroid) {
        // --- Android Play Integrity ---
        print("Requesting Play Integrity token with nonce: $nonce");
        // Use the specific methods provided by your chosen Play Integrity plugin
        // This often requires the nonce. Cloud project number might be needed
        // depending on the plugin and request type.
        attestationData = await PlayIntegrityFlutter.requestIntegrityToken(
             nonce: nonce,
             // cloudProjectNumber: YOUR_GOOGLE_CLOUD_PROJECT_NUMBER, // If required
        );
        print("Received Play Integrity Token.");

      } else if (Platform.isIOS) {
        // --- iOS App Attest ---
        print("Requesting App Attest assertion with nonce: $nonce");
        // 1. Generate or ensure key exists (might be done once)
        //    await FlutterAppAttest.generateKey(); // Example call

        // 2. Generate challenge hash (Nonce hashed with SHA256)
        var nonceBytes = utf8.encode(nonce);
        var nonceHash = sha256.convert(nonceBytes);
        var clientDataHash = nonceHash.bytes; // Use raw bytes

        // 3. Request assertion using the challenge hash
        //    Use the specific methods provided by your chosen App Attest plugin
        attestationData = await FlutterAppAttest.generateAssertion(clientDataHash);
         print("Received App Attest Assertion.");
      } else {
         print("Attestation not supported on this platform.");
         return false;
      }

      if (attestationData != null) {
        // Send the token/assertion and nonce to your backend for verification
        bool isValid = await _verifyTokenOnServer(attestationData, nonce);
        return isValid;
      } else {
        print("Failed to retrieve attestation data.");
        return false;
      }

    } on PlatformException catch (e) {
       print("Attestation failed: ${e.code} - ${e.message}");
       return false;
    } catch (e) {
       print("An unexpected error occurred during attestation: $e");
       return false;
    }
  }
}

// Example Usage (e.g., in a Button's onPressed):
// final attestationService = AttestationService();
// bool isDeviceVerified = await attestationService.attestDevice();
// if (isDeviceVerified) {
//   print("Device Attestation Successful!");
//   // Proceed with sensitive action
// } else {
//   print("Device Attestation Failed.");
//   // Handle failure - potentially block action or show error
// }
```

**5. Implement Backend Verification (Server-Side - The Most Important Part!)**

This code runs on your server, _not_ in the Flutter app.

- **Receive Request:** Create an API endpoint that receives the `attestationData` (token/assertion) and the `nonce` from the Flutter app.
- **Verify Nonce:** Ensure the received nonce is valid, hasn't expired, and hasn't been used before for this user/device.
- **Platform-Specific Verification:**
  - **Android (Play Integrity):**
    - Use the Google API client libraries (e.g., for Node.js, Python, Java, etc.).
    - Call the `decodeIntegrityToken` method of the Android Device Verification API, passing the received token.
    - **Crucially, verify the following in the decoded response:**
      - `requestDetails.nonce` matches the nonce you received from the app.
      - `requestDetails.appIntegrity.appRecognitionVerdict` is `PLAY_RECOGNIZED`.
      - `requestDetails.appIntegrity.packageName` matches your app's package name.
      - `requestDetails.appIntegrity.certificateSha256Digest` matches your app's signing certificate hash.
      - `deviceIntegrity.deviceRecognitionVerdict` meets your requirements (e.g., `MEETS_DEVICE_INTEGRITY`, potentially allow `MEETS_BASIC_INTEGRITY` depending on your security posture).
      - Check the `requestDetails.requestTimestampMillis` to ensure the request isn't too old.
  - **iOS (App Attest):**
    - You will receive a CBOR-encoded attestation object.
    - Parse the object. You'll need libraries for CBOR parsing and handling Apple's specific format.
    - **Verify the following:**
      - Extract the `authenticatorData` and verify its structure. Check the included public key matches what you might have stored during initial key generation/registration (if applicable).
      - Extract the `clientDataHash` from the `authenticatorData` and verify it matches the SHA256 hash of the nonce you sent to the app.
      - Verify the signature (`signature` field) using the public key from the `attestationStatement`.
      - Verify the `attestationStatement` itself by sending it to Apple's public validation endpoint or using appropriate libraries. Check the App ID, timestamp, etc.
- **Make Decision:** Based on the verification results (including nonce check), decide whether to trust the request from the device or reject it.

**Important Considerations**

- **Complexity:** App Attest verification on the backend is significantly more complex than Play Integrity. Use official libraries or well-vetted third-party ones.
- **Server-Side is Non-Negotiable:** Never trust attestation results processed only on the client. An attacker can easily bypass client-side checks.
- **Nonce Management:** Securely generate, track usage, and expire nonces on your server.
- **Error Handling:** Implement robust error handling on both client and server. What happens if attestation fails? Do you block the user, ask for MFA, or just log it?
- **Testing:** Testing attestation requires real devices. Emulators often don't support it or provide limited/fake results. You may need to register test devices in the Play Console / Apple Developer portal. Play Integrity also offers ways to force specific responses for testing.
- **Security Thresholds:** Decide what level of integrity you require (e.g., on Android, do you require `MEETS_DEVICE_INTEGRITY` or is `MEETS_BASIC_INTEGRITY` acceptable?). Understand the implications.
- **Read Official Docs:** Always refer to the latest official documentation from Google (Play Integrity) and Apple (App Attest) as APIs and best practices evolve.

Implementing device attestation is a significant security enhancement but requires careful implementation on both the Flutter client and, critically, your backend server.
