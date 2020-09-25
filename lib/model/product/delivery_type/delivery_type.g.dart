// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryType _$DeliveryTypeFromJson(Map<String, dynamic> json) {
  return DeliveryType(
    deliveryTypeId: json['delivery_type_id'] as String,
    instant: json['instant'] as int,
    day: json['day'] as int,
    orderStart: json['order_start'] == null
        ? null
        : DateTime.parse(json['order_start'] as String),
    orderEnd: json['order_end'] == null
        ? null
        : DateTime.parse(json['order_end'] as String),
    deliveryStart: json['delivery_start'] == null
        ? null
        : DateTime.parse(json['delivery_start'] as String),
    deliveryEnd: json['delivery_end'] == null
        ? null
        : DateTime.parse(json['delivery_end'] as String),
    caption: json['caption'] as String,
  );
}

Map<String, dynamic> _$DeliveryTypeToJson(DeliveryType instance) =>
    <String, dynamic>{
      'delivery_type_id': instance.deliveryTypeId,
      'instant': instance.instant,
      'day': instance.day,
      'order_start': instance.orderStart?.toIso8601String(),
      'order_end': instance.orderEnd?.toIso8601String(),
      'delivery_start': instance.deliveryStart?.toIso8601String(),
      'delivery_end': instance.deliveryEnd?.toIso8601String(),
      'caption': instance.caption,
    };
