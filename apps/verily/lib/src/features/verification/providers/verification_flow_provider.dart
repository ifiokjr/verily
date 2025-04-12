// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Unnecessary
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

import '../state/verification_flow_state.dart';
import '../../actions/providers/action_providers.dart'; // To get action details

part 'verification_flow_provider.g.dart';

/// Notifier to manage the state of the action verification flow.
@riverpod
class VerificationFlow extends _$VerificationFlow {
  @override
  VerificationFlowState build() {
    // Initial state when the provider is first created.
    return const VerificationFlowState();
  }

  /// Starts the verification flow for a given action ID.
  Future<void> startFlow(int actionId) async {
    // Prevent starting if already in progress
    if (state.flowStatus == FlowStatus.inProgress) return;

    // Reset state and set status to inProgress temporarily
    // We'll confirm this status after permission checks.
    state = const VerificationFlowState(flowStatus: FlowStatus.idle);

    // Fetch the action details (using the existing provider)
    final action = ref.read(actionDetailProvider(actionId));

    if (action == null || action.steps == null || action.steps!.isEmpty) {
      state = state.copyWith(
        flowStatus: FlowStatus.failed,
        errorMessage: 'Failed to load action or action has no steps.',
      );
      return;
    }

    // --- Permission Check ---
    final requiredPermissions = _getRequiredPermissions(action.steps!);
    if (requiredPermissions.isNotEmpty) {
      // Convert Set to List before requesting
      final statuses = await requiredPermissions.toList().request();
      final deniedPermissions =
          statuses.entries
              .where(
                (entry) => !entry.value.isGranted && !entry.value.isLimited,
              ) // isLimited applies to photos/location
              .map((entry) => entry.key)
              .toList();

      if (deniedPermissions.isNotEmpty) {
        final permissionNames = deniedPermissions
            .map((p) => p.toString().split('.').last)
            .join(', ');
        state = state.copyWith(
          flowStatus: FlowStatus.failed,
          errorMessage:
              'Required permissions denied: $permissionNames. Please grant permissions in settings.',
        );
        // Optionally: Guide user to settings using openAppSettings()
        // await openAppSettings();
        return; // Stop the flow if permissions are denied
      }
    }
    // --- End Permission Check ---

    // If permissions are granted, proceed with setting up the flow
    state = state.copyWith(
      flowStatus: FlowStatus.inProgress,
    ); // Now set to inProgress

    // Sort steps by order just in case
    final sortedSteps = List<vc.ActionStep>.from(action.steps!)
      ..sort((a, b) => a.order.compareTo(b.order));

    // Update state with the fetched action and sorted steps
    state = state.copyWith(
      action: action.copyWith(
        steps: sortedSteps,
      ), // Store action with sorted steps
      currentStepIndex: 0,
      stepStatuses: {},
      stepResults: {},
      errorMessage: null,
    );

    // Potentially trigger the first step execution here or wait for UI interaction
    debugPrint('Verification flow started for action: ${action.name}');
    debugPrint('First step: ${state.currentStep?.type}');
  }

  /// Determines the set of required permissions based on the action steps.
  Set<Permission> _getRequiredPermissions(List<vc.ActionStep> steps) {
    final permissions = <Permission>{};
    for (final step in steps) {
      switch (step.type) {
        case 'location':
          permissions.add(
            Permission.locationWhenInUse,
          ); // Or locationAlways if needed later
          break;
        case 'smile':
          permissions.add(Permission.camera);
          break;
        case 'speech':
          permissions.add(Permission.microphone);
          break;
        // Add cases for other step types requiring permissions
      }
    }
    return permissions;
  }

  /// Reports the success of the current step and advances to the next.
  void reportStepSuccess(dynamic result) {
    if (state.flowStatus != FlowStatus.inProgress ||
        state.currentStep == null) {
      // Added curly braces for consistency and Dart best practices
      return;
    }

    final currentIdx = state.currentStepIndex;
    final updatedStatuses = Map<int, StepStatus>.from(state.stepStatuses)
      ..[currentIdx] = StepStatus.success;
    final updatedResults = Map<int, dynamic>.from(state.stepResults)
      ..[currentIdx] = result; // Store step result

    // Check if this was the last step
    if (currentIdx >= state.action!.steps!.length - 1) {
      state = state.copyWith(
        flowStatus: FlowStatus.completed,
        stepStatuses: updatedStatuses,
        stepResults: updatedResults,
      );
      debugPrint('Verification flow completed successfully!');
      // TODO: Report completion to backend
    } else {
      // Advance to the next step
      state = state.copyWith(
        currentStepIndex: currentIdx + 1,
        stepStatuses: updatedStatuses,
        stepResults: updatedResults,
      );
      debugPrint(
        'Step $currentIdx successful. Advancing to step ${state.currentStepIndex}.',
      );
      debugPrint('Next step: ${state.currentStep?.type}');
    }
  }

  /// Reports the failure of the current step.
  void reportStepFailure(String errorMessage) {
    if (state.flowStatus != FlowStatus.inProgress ||
        state.currentStep == null) {
      // Added curly braces for consistency and Dart best practices
      return;
    }

    final currentIdx = state.currentStepIndex;
    final updatedStatuses = Map<int, StepStatus>.from(state.stepStatuses)
      ..[currentIdx] = StepStatus.failure;

    state = state.copyWith(
      flowStatus: FlowStatus.failed,
      stepStatuses: updatedStatuses,
      errorMessage:
          'Step ${currentIdx + 1} (${state.currentStep!.type}) failed: $errorMessage',
    );
    debugPrint('Step $currentIdx failed: $errorMessage');
    // TODO: Report failure to backend
  }

  /// Resets the flow state back to idle.
  void resetFlow() {
    state = const VerificationFlowState();
    debugPrint('Verification flow reset.');
  }
}
