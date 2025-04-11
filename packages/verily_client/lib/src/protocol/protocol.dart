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
import 'action_step.dart' as _i3;
import 'creator.dart' as _i4;
import 'example.dart' as _i5;
import 'verification_attempt.dart' as _i6;
import 'webhook.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
export 'action.dart';
export 'action_step.dart';
export 'creator.dart';
export 'example.dart';
export 'verification_attempt.dart';
export 'webhook.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Action) {
      return _i2.Action.fromJson(data) as T;
    }
    if (t == _i3.ActionStep) {
      return _i3.ActionStep.fromJson(data) as T;
    }
    if (t == _i4.Creator) {
      return _i4.Creator.fromJson(data) as T;
    }
    if (t == _i5.Example) {
      return _i5.Example.fromJson(data) as T;
    }
    if (t == _i6.VerificationAttempt) {
      return _i6.VerificationAttempt.fromJson(data) as T;
    }
    if (t == _i7.Webhook) {
      return _i7.Webhook.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Action?>()) {
      return (data != null ? _i2.Action.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ActionStep?>()) {
      return (data != null ? _i3.ActionStep.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Creator?>()) {
      return (data != null ? _i4.Creator.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Example?>()) {
      return (data != null ? _i5.Example.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.VerificationAttempt?>()) {
      return (data != null ? _i6.VerificationAttempt.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.Webhook?>()) {
      return (data != null ? _i7.Webhook.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i3.ActionStep>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i3.ActionStep>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i7.Webhook>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i7.Webhook>(e)).toList()
          : null) as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Action) {
      return 'Action';
    }
    if (data is _i3.ActionStep) {
      return 'ActionStep';
    }
    if (data is _i4.Creator) {
      return 'Creator';
    }
    if (data is _i5.Example) {
      return 'Example';
    }
    if (data is _i6.VerificationAttempt) {
      return 'VerificationAttempt';
    }
    if (data is _i7.Webhook) {
      return 'Webhook';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Action') {
      return deserialize<_i2.Action>(data['data']);
    }
    if (dataClassName == 'ActionStep') {
      return deserialize<_i3.ActionStep>(data['data']);
    }
    if (dataClassName == 'Creator') {
      return deserialize<_i4.Creator>(data['data']);
    }
    if (dataClassName == 'Example') {
      return deserialize<_i5.Example>(data['data']);
    }
    if (dataClassName == 'VerificationAttempt') {
      return deserialize<_i6.VerificationAttempt>(data['data']);
    }
    if (dataClassName == 'Webhook') {
      return deserialize<_i7.Webhook>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
