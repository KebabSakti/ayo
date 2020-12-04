// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetail _$PaymentDetailFromJson(Map<String, dynamic> json) {
  return PaymentDetail(
    id: json['id'] as int,
    paymentId: json['payment_id'] as String,
    saleId: json['sale_id'] as String,
    paymentMethod: json['payment_method'] as String,
    paymentFee: json['payment_fee'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    paymentStatus: json['payment_status'] == null
        ? null
        : PaymentStatus.fromJson(
            json['payment_status'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentDetailToJson(PaymentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_id': instance.paymentId,
      'sale_id': instance.saleId,
      'payment_method': instance.paymentMethod,
      'payment_fee': instance.paymentFee,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'payment_status': instance.paymentStatus,
    };
