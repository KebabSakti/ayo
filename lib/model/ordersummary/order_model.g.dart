// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as int,
    saleId: json['sale_id'] as String,
    customerId: json['customer_id'] as String,
    code: json['code'] as int,
    voucher: json['voucher'] as String,
    voucherAmount: json['voucher_amount'] as int,
    subTotal: json['sub_total'] as int,
    total: json['total'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'sale_id': instance.saleId,
      'customer_id': instance.customerId,
      'code': instance.code,
      'voucher': instance.voucher,
      'voucher_amount': instance.voucherAmount,
      'sub_total': instance.subTotal,
      'total': instance.total,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
