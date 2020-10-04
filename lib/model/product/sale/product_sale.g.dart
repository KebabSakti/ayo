// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSale _$ProductSaleFromJson(Map<String, dynamic> json) {
  return ProductSale(
    id: json['id'] as int,
    productSaleId: json['productSaleId'] as String,
    productId: json['productId'] as String,
    qtyTotal: json['qtyTotal'] as int,
    amountTotal: (json['amountTotal'] as num)?.toDouble(),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$ProductSaleToJson(ProductSale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productSaleId': instance.productSaleId,
      'productId': instance.productId,
      'qtyTotal': instance.qtyTotal,
      'amountTotal': instance.amountTotal,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
