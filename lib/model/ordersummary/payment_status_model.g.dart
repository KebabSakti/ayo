// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatus _$PaymentStatusFromJson(Map<String, dynamic> json) {
  return PaymentStatus(
    id: json['id'] as int,
    paymentStatusId: json['payment_status_id'] as String,
    saleId: json['sale_id'] as String,
    status: json['status'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$PaymentStatusToJson(PaymentStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_status_id': instance.paymentStatusId,
      'sale_id': instance.saleId,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
