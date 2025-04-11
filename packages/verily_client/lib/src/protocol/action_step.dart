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

abstract class ActionStep implements _i1.SerializableModel {
  ActionStep._({
    this.id,
    required this.actionId,
    required this.type,
    required this.order,
    required this.parameters,
    this.instruction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActionStep({
    int? id,
    required int actionId,
    required String type,
    required int order,
    required String parameters,
    String? instruction,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionStepImpl;

  factory ActionStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionStep(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      type: jsonSerialization['type'] as String,
      order: jsonSerialization['order'] as int,
      parameters: jsonSerialization['parameters'] as String,
      instruction: jsonSerialization['instruction'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  String type;

  int order;

  String parameters;

  String? instruction;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionStep copyWith({
    int? id,
    int? actionId,
    String? type,
    int? order,
    String? parameters,
    String? instruction,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'type': type,
      'order': order,
      'parameters': parameters,
      if (instruction != null) 'instruction': instruction,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
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
    required String type,
    required int order,
    required String parameters,
    String? instruction,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          actionId: actionId,
          type: type,
          order: order,
          parameters: parameters,
          instruction: instruction,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionStep copyWith({
    Object? id = _Undefined,
    int? actionId,
    String? type,
    int? order,
    String? parameters,
    Object? instruction = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActionStep(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      type: type ?? this.type,
      order: order ?? this.order,
      parameters: parameters ?? this.parameters,
      instruction: instruction is String? ? instruction : this.instruction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
