import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verily_client/verily_client.dart' as vc;

part 'verification_flow_state.freezed.dart';

/// Represents the overall status of the verification flow.
enum FlowStatus {
  idle, // Not started
  inProgress, // Actively verifying steps
  completed, // All steps successfully verified
  failed, // The flow failed at some point
}

/// Represents the status of an individual step.
enum StepStatus {
  pending, // Not yet attempted
  success, // Successfully verified
  failure, // Verification failed for this step
  skipped, // Step was skipped (optional)
}

/// State for managing the action verification process.
@freezed
class VerificationFlowState with _$VerificationFlowState {
  const factory VerificationFlowState({
    /// The action currently being verified.
    vc.Action? action,

    /// The overall status of the verification flow.
    @Default(FlowStatus.idle) FlowStatus flowStatus,

    /// The index of the current step being processed.
    @Default(0) int currentStepIndex,

    /// Stores the status of each step (keyed by step index).
    @Default({}) Map<int, StepStatus> stepStatuses,

    /// Stores any results from successful steps (keyed by step index).
    @Default({}) Map<int, dynamic> stepResults,

    /// Stores an error message if the flow failed.
    String? errorMessage,
  }) = _VerificationFlowState;

  const VerificationFlowState._(); // Private constructor for potential helpers

  /// Convenience getter for the current step based on the index.
  vc.ActionStep? get currentStep {
    if (action == null ||
        action!.steps == null ||
        currentStepIndex < 0 ||
        currentStepIndex >= action!.steps!.length) {
      return null;
    }
    // Ensure steps are sorted by order if not already guaranteed
    final sortedSteps = List<vc.ActionStep>.from(action!.steps!)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sortedSteps[currentStepIndex];
  }

  /// Check if all steps are completed successfully.
  bool get areAllStepsCompleted {
    if (action == null || action!.steps == null || action!.steps!.isEmpty) {
      return false;
    }
    return stepStatuses.length == action!.steps!.length &&
        stepStatuses.values.every((status) => status == StepStatus.success);
  }
}
