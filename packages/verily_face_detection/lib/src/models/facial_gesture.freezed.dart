// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facial_gesture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FacialGesture _$FacialGestureFromJson(Map<String, dynamic> json) {
  return _FacialGesture.fromJson(json);
}

/// @nodoc
mixin _$FacialGesture {
  GestureType get type => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this FacialGesture to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacialGesture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacialGestureCopyWith<FacialGesture> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacialGestureCopyWith<$Res> {
  factory $FacialGestureCopyWith(
    FacialGesture value,
    $Res Function(FacialGesture) then,
  ) = _$FacialGestureCopyWithImpl<$Res, FacialGesture>;
  @useResult
  $Res call({GestureType type, double confidence, DateTime timestamp});
}

/// @nodoc
class _$FacialGestureCopyWithImpl<$Res, $Val extends FacialGesture>
    implements $FacialGestureCopyWith<$Res> {
  _$FacialGestureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacialGesture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? confidence = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GestureType,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FacialGestureImplCopyWith<$Res>
    implements $FacialGestureCopyWith<$Res> {
  factory _$$FacialGestureImplCopyWith(
    _$FacialGestureImpl value,
    $Res Function(_$FacialGestureImpl) then,
  ) = __$$FacialGestureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GestureType type, double confidence, DateTime timestamp});
}

/// @nodoc
class __$$FacialGestureImplCopyWithImpl<$Res>
    extends _$FacialGestureCopyWithImpl<$Res, _$FacialGestureImpl>
    implements _$$FacialGestureImplCopyWith<$Res> {
  __$$FacialGestureImplCopyWithImpl(
    _$FacialGestureImpl _value,
    $Res Function(_$FacialGestureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FacialGesture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? confidence = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$FacialGestureImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GestureType,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FacialGestureImpl implements _FacialGesture {
  const _$FacialGestureImpl({
    required this.type,
    required this.confidence,
    required this.timestamp,
  });

  factory _$FacialGestureImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacialGestureImplFromJson(json);

  @override
  final GestureType type;
  @override
  final double confidence;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'FacialGesture(type: $type, confidence: $confidence, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacialGestureImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, confidence, timestamp);

  /// Create a copy of FacialGesture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacialGestureImplCopyWith<_$FacialGestureImpl> get copyWith =>
      __$$FacialGestureImplCopyWithImpl<_$FacialGestureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacialGestureImplToJson(this);
  }
}

abstract class _FacialGesture implements FacialGesture {
  const factory _FacialGesture({
    required final GestureType type,
    required final double confidence,
    required final DateTime timestamp,
  }) = _$FacialGestureImpl;

  factory _FacialGesture.fromJson(Map<String, dynamic> json) =
      _$FacialGestureImpl.fromJson;

  @override
  GestureType get type;
  @override
  double get confidence;
  @override
  DateTime get timestamp;

  /// Create a copy of FacialGesture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacialGestureImplCopyWith<_$FacialGestureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
