// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) {
  return Discount(
    discountId: json['discount_id'] as String,
    productId: json['product_id'] as String,
    amount: json['amount'] as String,
    active: json['active'] as int,
    expiredAt: json['expired_at'] as String,
    created_at: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'discount_id': instance.discountId,
      'product_id': instance.productId,
      'amount': instance.amount,
      'active': instance.active,
      'expired_at': instance.expiredAt,
      'created_at': instance.created_at,
      'updated_at': instance.updatedAt,
    };
