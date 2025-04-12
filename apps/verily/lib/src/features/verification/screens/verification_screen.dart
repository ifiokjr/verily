import 'dart:convert'; // For jsonDecode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import permission_handler for openAppSettings
import 'package:permission_handler/permission_handler.dart';

import '../providers/verification_flow_provider.dart';
import '../state/verification_flow_state.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Corrected import paths for the specific step widgets
import '../widgets/location_step_widget.dart';
import '../widgets/smile_step_widget.dart';
import '../widgets/speech_step_widget.dart';

/// Screen that guides the user through the action verification steps.
/// Needs to be stateful to trigger the flow start in initState.
class VerificationScreen extends ConsumerStatefulWidget {
  /// The ID of the action to be verified.
  /// Received from the route parameters, typically via deep link.
  final int actionId;

  const VerificationScreen({required this.actionId, super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the provider is available
    // and to avoid triggering state changes during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Read the current state and notifier.
      final flowState = ref.read(verificationFlowProvider);
      final flowNotifier = ref.read(verificationFlowProvider.notifier);

      // Start the flow only if it's idle or for a different action ID.
      // This prevents restarting if the screen is rebuilt for other reasons.
      if (flowState.flowStatus == FlowStatus.idle ||
          flowState.action?.id != widget.actionId) {
        flowNotifier.startFlow(widget.actionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state of the verification flow.
    final flowState = ref.watch(verificationFlowProvider);
    // Read notifier (no need to re-read in build if already read in initState/other methods)
    final flowNotifier = ref.read(verificationFlowProvider.notifier);

    // Use widget.actionId if needed for displaying initial info before flowState.action is populated
    final actionName =
        flowState.action?.name ?? 'Verification (ID: ${widget.actionId})';

    // Check for permission denial error specifically
    bool showPermissionError =
        flowState.flowStatus == FlowStatus.failed &&
        flowState.errorMessage?.contains('permissions denied') == true;

    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying: $actionName'),
        leading:
            flowState.flowStatus == FlowStatus.inProgress || showPermissionError
                ? IconButton(
                  icon: const Icon(Icons.close), // Use close instead of cancel
                  tooltip: 'Close Verification',
                  onPressed: () {
                    flowNotifier.resetFlow(); // Reset flow state
                    // Always pop if possible when user explicitly closes
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                )
                : null, // No close button if completed or idle (before start)
      ),
      // Use a helper build method from the State class
      body: _buildBody(context, flowState, flowNotifier, showPermissionError),
    );
  }

  // Helper to build the body based on the flow state
  Widget _buildBody(
    BuildContext context,
    VerificationFlowState flowState,
    VerificationFlow flowNotifier,
    bool showPermissionError,
  ) {
    // Handle permission error state first
    if (showPermissionError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.orange, size: 80),
              const SizedBox(height: 16),
              Text(
                'Permissions Required',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                flowState.errorMessage ?? 'Required permissions were denied.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Attempt to open app settings for the user
                  await openAppSettings();
                },
                child: const Text('Open App Settings'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  flowNotifier.resetFlow();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    }

    // Original switch statement for other states
    switch (flowState.flowStatus) {
      case FlowStatus.idle:
        // Show initializing state while permissions might be checked or flow starts
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing verification...'),
            ],
          ),
        );

      case FlowStatus.inProgress:
        final step = flowState.currentStep;
        if (step == null) {
          // Should not happen if startFlow worked correctly and permissions granted
          return const Center(child: Text('Error: No current step found.'));
        }
        // Display the widget for the current step type
        return _buildStepWidget(context, step, flowNotifier);

      case FlowStatus.completed:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'Verification Complete!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  flowNotifier.resetFlow();
                  // Navigate back or to a results screen
                  if (Navigator.canPop(context)) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );

      case FlowStatus.failed:
        // This handles failures *other* than permission denial
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 16),
              Text(
                'Verification Failed',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                flowState.errorMessage ?? 'An unknown error occurred.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  flowNotifier.resetFlow();
                  // Navigate back
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Try Again Later'),
              ),
            ],
          ),
        );
    }
  }

  // Helper to select the appropriate widget for the current step type
  Widget _buildStepWidget(
    BuildContext context,
    vc.ActionStep step,
    VerificationFlow flowNotifier,
  ) {
    Map<String, dynamic> params = {};
    try {
      if (step.parameters.isNotEmpty) {
        params = jsonDecode(step.parameters);
      }
    } catch (e) {
      // Log the error properly instead of printing
      // Logger().e('Error decoding step parameters: $e'); // Assuming a logger is set up
      debugPrint(
        'Error decoding step parameters: $e',
      ); // Use debugPrint for now
      flowNotifier.reportStepFailure('Invalid step parameters.');
      return const Center(
        child: Text('Error: Could not read step parameters.'),
      );
    }

    // Use actual step widgets based on step type
    switch (step.type) {
      case 'location':
        return LocationStepWidget(parameters: params, notifier: flowNotifier);
      case 'smile':
        return SmileStepWidget(parameters: params, notifier: flowNotifier);
      case 'speech':
        return SpeechStepWidget(parameters: params, notifier: flowNotifier);
      default:
        flowNotifier.reportStepFailure('Unsupported step type: ${step.type}');
        return Center(child: Text('Error: Unknown step type \'${step.type}\''));
    }
  }
}
