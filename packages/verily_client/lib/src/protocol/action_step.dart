/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'action.dart' as _i2;

abstract class ActionStep implements _i1.SerializableModel {
  ActionStep._({
    this.id,
    required this.actionId,
    this.action,
    required this.stepType,
    required this.parameters,
    required this.order,
    required this.createdAt,
  });

  factory ActionStep({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String stepType,
    required String parameters,
    required int order,
    required DateTime createdAt,
  }) = _ActionStepImpl;

  factory ActionStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionStep(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      action: jsonSerialization['action'] == null
          ? null
          : _i2.Action.fromJson(
              (jsonSerialization['action'] as Map<String, dynamic>)),
      stepType: jsonSerialization['stepType'] as String,
      parameters: jsonSerialization['parameters'] as String,
      order: jsonSerialization['order'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  _i2.Action? action;

  String stepType;

  String parameters;

  int order;

  DateTime createdAt;

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionStep copyWith({
    int? id,
    int? actionId,
    _i2.Action? action,
    String? stepType,
    String? parameters,
    int? order,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJson(),
      'stepType': stepType,
      'parameters': parameters,
      'order': order,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionStepImpl extends ActionStep {
  _ActionStepImpl({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String stepType,
    required String parameters,
    required int order,
    required DateTime createdAt,
  }) : super._(
          id: id,
          actionId: actionId,
          action: action,
          stepType: stepType,
          parameters: parameters,
          order: order,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionStep copyWith({
    Object? id = _Undefined,
    int? actionId,
    Object? action = _Undefined,
    String? stepType,
    String? parameters,
    int? order,
    DateTime? createdAt,
  }) {
    return ActionStep(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      action: action is _i2.Action? ? action : this.action?.copyWith(),
      stepType: stepType ?? this.stepType,
      parameters: parameters ?? this.parameters,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
