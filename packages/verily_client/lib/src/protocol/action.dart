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
    required this.description,
    required this.creatorId,
    this.steps,
    this.webhooks,
    required this.createdAt,
  });

  factory Action({
    int? id,
    required String name,
    required String description,
    required int creatorId,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
    required DateTime createdAt,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      creatorId: jsonSerialization['creatorId'] as int,
      steps: (jsonSerialization['steps'] as List?)
          ?.map((e) => _i2.ActionStep.fromJson((e as Map<String, dynamic>)))
          .toList(),
      webhooks: (jsonSerialization['webhooks'] as List?)
          ?.map((e) => _i3.Webhook.fromJson((e as Map<String, dynamic>)))
          .toList(),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  int creatorId;

  List<_i2.ActionStep>? steps;

  List<_i3.Webhook>? webhooks;

  DateTime createdAt;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    String? name,
    String? description,
    int? creatorId,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      if (steps != null) 'steps': steps?.toJson(valueToJson: (v) => v.toJson()),
      if (webhooks != null)
        'webhooks': webhooks?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
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
    required String description,
    required int creatorId,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
    required DateTime createdAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          creatorId: creatorId,
          steps: steps,
          webhooks: webhooks,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    int? creatorId,
    Object? steps = _Undefined,
    Object? webhooks = _Undefined,
    DateTime? createdAt,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      steps: steps is List<_i2.ActionStep>?
          ? steps
          : this.steps?.map((e0) => e0.copyWith()).toList(),
      webhooks: webhooks is List<_i3.Webhook>?
          ? webhooks
          : this.webhooks?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
