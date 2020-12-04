// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Courier _$CourierFromJson(Map<String, dynamic> json) {
  return Courier(
    id: json['id'] as int,
    courierId: json['courier_id'] as String,
    mitraId: json['mitra_id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    picture: json['picture'] as String,
    active: json['active'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$CourierToJson(Courier instance) => <String, dynamic>{
      'id': instance.id,
      'courier_id': instance.courierId,
      'mitra_id': instance.mitraId,
      'name': instance.name,
      'phone': instance.phone,
      'picture': instance.picture,
      'active': instance.active,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
