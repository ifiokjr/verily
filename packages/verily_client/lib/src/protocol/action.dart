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
import 'action_step.dart' as _i2;
import 'webhook.dart' as _i3;

abstract class Action implements _i1.SerializableModel {
  Action._({
    this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    bool? isDeleted,
    this.steps,
    this.webhooks,
  }) : isDeleted = isDeleted ?? false;

  factory Action({
    int? id,
    required String name,
    String? description,
    required int creatorId,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      creatorId: jsonSerialization['creatorId'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      isDeleted: jsonSerialization['isDeleted'] as bool,
      steps: (jsonSerialization['steps'] as List?)
          ?.map((e) => _i2.ActionStep.fromJson((e as Map<String, dynamic>)))
          .toList(),
      webhooks: (jsonSerialization['webhooks'] as List?)
          ?.map((e) => _i3.Webhook.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  int creatorId;

  DateTime createdAt;

  DateTime updatedAt;

  bool isDeleted;

  List<_i2.ActionStep>? steps;

  List<_i3.Webhook>? webhooks;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    String? name,
    String? description,
    int? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'creatorId': creatorId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isDeleted': isDeleted,
      if (steps != null) 'steps': steps?.toJson(valueToJson: (v) => v.toJson()),
      if (webhooks != null)
        'webhooks': webhooks?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required String name,
    String? description,
    required int creatorId,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  }) : super._(
          id: id,
          name: name,
          description: description,
          creatorId: creatorId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isDeleted: isDeleted,
          steps: steps,
          webhooks: webhooks,
        );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    int? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Object? steps = _Undefined,
    Object? webhooks = _Undefined,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      steps: steps is List<_i2.ActionStep>?
          ? steps
          : this.steps?.map((e0) => e0.copyWith()).toList(),
      webhooks: webhooks is List<_i3.Webhook>?
          ? webhooks
          : this.webhooks?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
