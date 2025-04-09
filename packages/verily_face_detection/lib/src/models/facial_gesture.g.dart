// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facial_gesture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacialGestureImpl _$$FacialGestureImplFromJson(Map<String, dynamic> json) =>
    _$FacialGestureImpl(
      type: $enumDecode(_$GestureTypeEnumMap, json['type']),
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$FacialGestureImplToJson(_$FacialGestureImpl instance) =>
    <String, dynamic>{
      'type': _$GestureTypeEnumMap[instance.type]!,
      'confidence': instance.confidence,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$GestureTypeEnumMap = {
  GestureType.smile: 'smile',
  GestureType.wink: 'wink',
  GestureType.blink: 'blink',
  GestureType.frown: 'frown',
  GestureType.openMouth: 'openMouth',
  GestureType.tongueOut: 'tongueOut',
};
