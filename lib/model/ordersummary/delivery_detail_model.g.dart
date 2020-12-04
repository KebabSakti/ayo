// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDetail _$DeliveryDetailFromJson(Map<String, dynamic> json) {
  return DeliveryDetail(
    id: json['id'] as int,
    deliveryDetailId: json['delivery_detail_id'] as String,
    saleId: json['sale_id'] as String,
    customerId: json['customer_id'] as String,
    courierId: json['courier_id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    address: json['address'] as String,
    distance: json['distance'] as int,
    eta: json['eta'] as int,
    fee: json['fee'] as int,
    note: json['note'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    couriers: (json['couriers'] as List)
        ?.map((e) =>
            e == null ? null : Courier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeliveryDetailToJson(DeliveryDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delivery_detail_id': instance.deliveryDetailId,
      'sale_id': instance.saleId,
      'customer_id': instance.customerId,
      'courier_id': instance.courierId,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'distance': instance.distance,
      'eta': instance.eta,
      'fee': instance.fee,
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'couriers': instance.couriers,
    };
