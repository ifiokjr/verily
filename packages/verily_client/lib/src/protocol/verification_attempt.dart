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

abstract class VerificationAttempt implements _i1.SerializableModel {
  VerificationAttempt._({
    this.id,
    required this.actionId,
    required this.userId,
    required this.status,
    required this.startedAt,
    this.lastUpdatedAt,
    this.stepProgress,
    this.errorMessage,
  });

  factory VerificationAttempt({
    int? id,
    required int actionId,
    required String userId,
    required String status,
    required DateTime startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  }) = _VerificationAttemptImpl;

  factory VerificationAttempt.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationAttempt(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      userId: jsonSerialization['userId'] as String,
      status: jsonSerialization['status'] as String,
      startedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      lastUpdatedAt:
          jsonSerialization['lastUpdatedAt'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                jsonSerialization['lastUpdatedAt'],
              ),
      stepProgress: jsonSerialization['stepProgress'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  String userId;

  String status;

  DateTime startedAt;

  DateTime? lastUpdatedAt;

  String? stepProgress;

  String? errorMessage;

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationAttempt copyWith({
    int? id,
    int? actionId,
    String? userId,
    String? status,
    DateTime? startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'userId': userId,
      'status': status,
      'startedAt': startedAt.toJson(),
      if (lastUpdatedAt != null) 'lastUpdatedAt': lastUpdatedAt?.toJson(),
      if (stepProgress != null) 'stepProgress': stepProgress,
      if (errorMessage != null) 'errorMessage': errorMessage,
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
    required String userId,
    required String status,
    required DateTime startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  }) : super._(
         id: id,
         actionId: actionId,
         userId: userId,
         status: status,
         startedAt: startedAt,
         lastUpdatedAt: lastUpdatedAt,
         stepProgress: stepProgress,
         errorMessage: errorMessage,
       );

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationAttempt copyWith({
    Object? id = _Undefined,
    int? actionId,
    String? userId,
    String? status,
    DateTime? startedAt,
    Object? lastUpdatedAt = _Undefined,
    Object? stepProgress = _Undefined,
    Object? errorMessage = _Undefined,
  }) {
    return VerificationAttempt(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      lastUpdatedAt:
          lastUpdatedAt is DateTime? ? lastUpdatedAt : this.lastUpdatedAt,
      stepProgress: stepProgress is String? ? stepProgress : this.stepProgress,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
    );
  }
}
