import 'dart:convert'; // For jsonDecode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/verification_flow_provider.dart';
import '../state/verification_flow_state.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Corrected import paths for the specific step widgets
import '../widgets/location_step_widget.dart';
import '../widgets/smile_step_widget.dart';
import '../widgets/speech_step_widget.dart';

/// Screen that guides the user through the action verification steps.
class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of the verification flow.
    final flowState = ref.watch(verificationFlowProvider);
    final flowNotifier = ref.read(verificationFlowProvider.notifier);

    final currentStep = flowState.currentStep;
    final actionName = flowState.action?.name ?? 'Verification';

    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying: $actionName'),
        leading:
            flowState.flowStatus == FlowStatus.inProgress
                ? IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  tooltip: 'Cancel Verification',
                  onPressed: () {
                    // Optionally show confirmation dialog
                    flowNotifier.resetFlow();
                    // Pop the screen if cancellation is confirmed/immediate
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                )
                : null, // No cancel button if not in progress
      ),
      body: _buildBody(context, flowState, flowNotifier),
    );
  }

  // Helper to build the body based on the flow state
  Widget _buildBody(
    BuildContext context,
    VerificationFlowState flowState,
    VerificationFlow flowNotifier,
  ) {
    switch (flowState.flowStatus) {
      case FlowStatus.idle:
        return const Center(child: Text('Initializing verification...'));

      case FlowStatus.inProgress:
        final step = flowState.currentStep;
        if (step == null) {
          // Should not happen if startFlow worked correctly
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
      print('Error decoding step parameters: $e');
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
        // Smile step might not use parameters, but pass them for consistency for now
        return SmileStepWidget(parameters: params, notifier: flowNotifier);
      case 'speech':
        return SpeechStepWidget(parameters: params, notifier: flowNotifier);
      default:
        flowNotifier.reportStepFailure('Unsupported step type: ${step.type}');
        return Center(child: Text('Error: Unknown step type \'${step.type}\''));
    }
  }
}
