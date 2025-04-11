// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerificationFlowState {
  /// The action currently being verified.
  vc.Action? get action;

  /// The overall status of the verification flow.
  FlowStatus get flowStatus;

  /// The index of the current step being processed.
  int get currentStepIndex;

  /// Stores the status of each step (keyed by step index).
  Map<int, StepStatus> get stepStatuses;

  /// Stores any results from successful steps (keyed by step index).
  Map<int, dynamic> get stepResults;

  /// Stores an error message if the flow failed.
  String? get errorMessage;

  /// Create a copy of VerificationFlowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerificationFlowStateCopyWith<VerificationFlowState> get copyWith =>
      _$VerificationFlowStateCopyWithImpl<VerificationFlowState>(
          this as VerificationFlowState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerificationFlowState &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.flowStatus, flowStatus) ||
                other.flowStatus == flowStatus) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            const DeepCollectionEquality()
                .equals(other.stepStatuses, stepStatuses) &&
            const DeepCollectionEquality()
                .equals(other.stepResults, stepResults) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      action,
      flowStatus,
      currentStepIndex,
      const DeepCollectionEquality().hash(stepStatuses),
      const DeepCollectionEquality().hash(stepResults),
      errorMessage);

  @override
  String toString() {
    return 'VerificationFlowState(action: $action, flowStatus: $flowStatus, currentStepIndex: $currentStepIndex, stepStatuses: $stepStatuses, stepResults: $stepResults, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $VerificationFlowStateCopyWith<$Res> {
  factory $VerificationFlowStateCopyWith(VerificationFlowState value,
          $Res Function(VerificationFlowState) _then) =
      _$VerificationFlowStateCopyWithImpl;
  @useResult
  $Res call(
      {vc.Action? action,
      FlowStatus flowStatus,
      int currentStepIndex,
      Map<int, StepStatus> stepStatuses,
      Map<int, dynamic> stepResults,
      String? errorMessage});
}

/// @nodoc
class _$VerificationFlowStateCopyWithImpl<$Res>
    implements $VerificationFlowStateCopyWith<$Res> {
  _$VerificationFlowStateCopyWithImpl(this._self, this._then);

  final VerificationFlowState _self;
  final $Res Function(VerificationFlowState) _then;

  /// Create a copy of VerificationFlowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = freezed,
    Object? flowStatus = null,
    Object? currentStepIndex = null,
    Object? stepStatuses = null,
    Object? stepResults = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as vc.Action?,
      flowStatus: null == flowStatus
          ? _self.flowStatus
          : flowStatus // ignore: cast_nullable_to_non_nullable
              as FlowStatus,
      currentStepIndex: null == currentStepIndex
          ? _self.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      stepStatuses: null == stepStatuses
          ? _self.stepStatuses
          : stepStatuses // ignore: cast_nullable_to_non_nullable
              as Map<int, StepStatus>,
      stepResults: null == stepResults
          ? _self.stepResults
          : stepResults // ignore: cast_nullable_to_non_nullable
              as Map<int, dynamic>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _VerificationFlowState extends VerificationFlowState {
  const _VerificationFlowState(
      {this.action,
      this.flowStatus = FlowStatus.idle,
      this.currentStepIndex = 0,
      final Map<int, StepStatus> stepStatuses = const {},
      final Map<int, dynamic> stepResults = const {},
      this.errorMessage})
      : _stepStatuses = stepStatuses,
        _stepResults = stepResults,
        super._();

  /// The action currently being verified.
  @override
  final vc.Action? action;

  /// The overall status of the verification flow.
  @override
  @JsonKey()
  final FlowStatus flowStatus;

  /// The index of the current step being processed.
  @override
  @JsonKey()
  final int currentStepIndex;

  /// Stores the status of each step (keyed by step index).
  final Map<int, StepStatus> _stepStatuses;

  /// Stores the status of each step (keyed by step index).
  @override
  @JsonKey()
  Map<int, StepStatus> get stepStatuses {
    if (_stepStatuses is EqualUnmodifiableMapView) return _stepStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stepStatuses);
  }

  /// Stores any results from successful steps (keyed by step index).
  final Map<int, dynamic> _stepResults;

  /// Stores any results from successful steps (keyed by step index).
  @override
  @JsonKey()
  Map<int, dynamic> get stepResults {
    if (_stepResults is EqualUnmodifiableMapView) return _stepResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stepResults);
  }

  /// Stores an error message if the flow failed.
  @override
  final String? errorMessage;

  /// Create a copy of VerificationFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerificationFlowStateCopyWith<_VerificationFlowState> get copyWith =>
      __$VerificationFlowStateCopyWithImpl<_VerificationFlowState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerificationFlowState &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.flowStatus, flowStatus) ||
                other.flowStatus == flowStatus) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            const DeepCollectionEquality()
                .equals(other._stepStatuses, _stepStatuses) &&
            const DeepCollectionEquality()
                .equals(other._stepResults, _stepResults) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      action,
      flowStatus,
      currentStepIndex,
      const DeepCollectionEquality().hash(_stepStatuses),
      const DeepCollectionEquality().hash(_stepResults),
      errorMessage);

  @override
  String toString() {
    return 'VerificationFlowState(action: $action, flowStatus: $flowStatus, currentStepIndex: $currentStepIndex, stepStatuses: $stepStatuses, stepResults: $stepResults, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$VerificationFlowStateCopyWith<$Res>
    implements $VerificationFlowStateCopyWith<$Res> {
  factory _$VerificationFlowStateCopyWith(_VerificationFlowState value,
          $Res Function(_VerificationFlowState) _then) =
      __$VerificationFlowStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {vc.Action? action,
      FlowStatus flowStatus,
      int currentStepIndex,
      Map<int, StepStatus> stepStatuses,
      Map<int, dynamic> stepResults,
      String? errorMessage});
}

/// @nodoc
class __$VerificationFlowStateCopyWithImpl<$Res>
    implements _$VerificationFlowStateCopyWith<$Res> {
  __$VerificationFlowStateCopyWithImpl(this._self, this._then);

  final _VerificationFlowState _self;
  final $Res Function(_VerificationFlowState) _then;

  /// Create a copy of VerificationFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? action = freezed,
    Object? flowStatus = null,
    Object? currentStepIndex = null,
    Object? stepStatuses = null,
    Object? stepResults = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_VerificationFlowState(
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as vc.Action?,
      flowStatus: null == flowStatus
          ? _self.flowStatus
          : flowStatus // ignore: cast_nullable_to_non_nullable
              as FlowStatus,
      currentStepIndex: null == currentStepIndex
          ? _self.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      stepStatuses: null == stepStatuses
          ? _self._stepStatuses
          : stepStatuses // ignore: cast_nullable_to_non_nullable
              as Map<int, StepStatus>,
      stepResults: null == stepResults
          ? _self._stepResults
          : stepResults // ignore: cast_nullable_to_non_nullable
              as Map<int, dynamic>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
