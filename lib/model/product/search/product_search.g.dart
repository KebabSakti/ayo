// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearch _$ProductSearchFromJson(Map<String, dynamic> json) {
  return ProductSearch(
    id: json['id'] as int,
    productSearchId: json['productSearchId'] as String,
    productId: json['productId'] as String,
    hits: json['hits'] as int,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$ProductSearchToJson(ProductSearch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productSearchId': instance.productSearchId,
      'productId': instance.productId,
      'hits': instance.hits,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
