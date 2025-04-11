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
    required this.userInfoId,
    this.locationId,
    this.validFrom,
    this.validUntil,
    this.maxCompletionTimeSeconds,
    bool? strictOrder,
    required this.createdAt,
    required this.updatedAt,
    bool? isDeleted,
    this.steps,
    this.webhooks,
  })  : strictOrder = strictOrder ?? true,
        isDeleted = isDeleted ?? false;

  factory Action({
    int? id,
    required String name,
    String? description,
    required int userInfoId,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
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
      userInfoId: jsonSerialization['userInfoId'] as int,
      locationId: jsonSerialization['locationId'] as int?,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
      maxCompletionTimeSeconds:
          jsonSerialization['maxCompletionTimeSeconds'] as int?,
      strictOrder: jsonSerialization['strictOrder'] as bool,
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

  int userInfoId;

  int? locationId;

  DateTime? validFrom;

  DateTime? validUntil;

  int? maxCompletionTimeSeconds;

  bool strictOrder;

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
    int? userInfoId,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
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
      'userInfoId': userInfoId,
      if (locationId != null) 'locationId': locationId,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      if (maxCompletionTimeSeconds != null)
        'maxCompletionTimeSeconds': maxCompletionTimeSeconds,
      'strictOrder': strictOrder,
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
    required int userInfoId,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  }) : super._(
          id: id,
          name: name,
          description: description,
          userInfoId: userInfoId,
          locationId: locationId,
          validFrom: validFrom,
          validUntil: validUntil,
          maxCompletionTimeSeconds: maxCompletionTimeSeconds,
          strictOrder: strictOrder,
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
    int? userInfoId,
    Object? locationId = _Undefined,
    Object? validFrom = _Undefined,
    Object? validUntil = _Undefined,
    Object? maxCompletionTimeSeconds = _Undefined,
    bool? strictOrder,
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
      userInfoId: userInfoId ?? this.userInfoId,
      locationId: locationId is int? ? locationId : this.locationId,
      validFrom: validFrom is DateTime? ? validFrom : this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
      maxCompletionTimeSeconds: maxCompletionTimeSeconds is int?
          ? maxCompletionTimeSeconds
          : this.maxCompletionTimeSeconds,
      strictOrder: strictOrder ?? this.strictOrder,
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
