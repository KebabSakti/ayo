// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSale _$ProductSaleFromJson(Map<String, dynamic> json) {
  return ProductSale(
    id: json['id'] as int,
    productSaleId: json['product_sale_id'] as String,
    productId: json['product_id'] as String,
    qtyTotal: json['qty_total'] as int,
    amountTotal: ProductSale._fromDouble(json['amount_total'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ProductSaleToJson(ProductSale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_sale_id': instance.productSaleId,
      'product_id': instance.productId,
      'qty_total': instance.qtyTotal,
      'amount_total': instance.amountTotal,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
