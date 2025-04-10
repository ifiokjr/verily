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

abstract class VerificationAttempt implements _i1.SerializableModel {
  VerificationAttempt._({
    this.id,
    required this.actionId,
    this.action,
    required this.userId,
    required this.status,
    required this.startedAt,
    required this.updatedAt,
    this.completedAt,
    this.progressData,
  });

  factory VerificationAttempt({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String userId,
    required String status,
    required DateTime startedAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    String? progressData,
  }) = _VerificationAttemptImpl;

  factory VerificationAttempt.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationAttempt(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      action: jsonSerialization['action'] == null
          ? null
          : _i2.Action.fromJson(
              (jsonSerialization['action'] as Map<String, dynamic>)),
      userId: jsonSerialization['userId'] as String,
      status: jsonSerialization['status'] as String,
      startedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt']),
      progressData: jsonSerialization['progressData'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  _i2.Action? action;

  String userId;

  String status;

  DateTime startedAt;

  DateTime updatedAt;

  DateTime? completedAt;

  String? progressData;

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationAttempt copyWith({
    int? id,
    int? actionId,
    _i2.Action? action,
    String? userId,
    String? status,
    DateTime? startedAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? progressData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJson(),
      'userId': userId,
      'status': status,
      'startedAt': startedAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (progressData != null) 'progressData': progressData,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationAttemptImpl extends VerificationAttempt {
  _VerificationAttemptImpl({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String userId,
    required String status,
    required DateTime startedAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    String? progressData,
  }) : super._(
          id: id,
          actionId: actionId,
          action: action,
          userId: userId,
          status: status,
          startedAt: startedAt,
          updatedAt: updatedAt,
          completedAt: completedAt,
          progressData: progressData,
        );

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationAttempt copyWith({
    Object? id = _Undefined,
    int? actionId,
    Object? action = _Undefined,
    String? userId,
    String? status,
    DateTime? startedAt,
    DateTime? updatedAt,
    Object? completedAt = _Undefined,
    Object? progressData = _Undefined,
  }) {
    return VerificationAttempt(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      action: action is _i2.Action? ? action : this.action?.copyWith(),
      userId: userId ?? this.userId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      progressData: progressData is String? ? progressData : this.progressData,
    );
  }
}
