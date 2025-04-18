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

abstract class Webhook implements _i1.SerializableModel {
  Webhook._({
    this.id,
    required this.actionId,
    required this.url,
    this.secret,
    required this.subscribedEvents,
    bool? isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true;

  factory Webhook({
    int? id,
    required int actionId,
    required String url,
    String? secret,
    required String subscribedEvents,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WebhookImpl;

  factory Webhook.fromJson(Map<String, dynamic> jsonSerialization) {
    return Webhook(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      url: jsonSerialization['url'] as String,
      secret: jsonSerialization['secret'] as String?,
      subscribedEvents: jsonSerialization['subscribedEvents'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  String url;

  String? secret;

  String subscribedEvents;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Webhook copyWith({
    int? id,
    int? actionId,
    String? url,
    String? secret,
    String? subscribedEvents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'url': url,
      if (secret != null) 'secret': secret,
      'subscribedEvents': subscribedEvents,
      'isActive': isActive,
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

class _WebhookImpl extends Webhook {
  _WebhookImpl({
    int? id,
    required int actionId,
    required String url,
    String? secret,
    required String subscribedEvents,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         actionId: actionId,
         url: url,
         secret: secret,
         subscribedEvents: subscribedEvents,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Webhook copyWith({
    Object? id = _Undefined,
    int? actionId,
    String? url,
    Object? secret = _Undefined,
    String? subscribedEvents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Webhook(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      url: url ?? this.url,
      secret: secret is String? ? secret : this.secret,
      subscribedEvents: subscribedEvents ?? this.subscribedEvents,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
