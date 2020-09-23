// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    productId: json['product_id'] as String,
    subCategoryId: json['sub_category_id'] as String,
    cover: json['cover'] as String,
    name: json['name'] as String,
    caption: json['caption'] as String,
    price: (json['price'] as num)?.toDouble(),
    tag: json['tag'] as String,
    link: json['link'] as String,
    active: json['active'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    deliveryType: json['delivery_type'] == null
        ? null
        : DeliveryType.fromJson(json['delivery_type'] as Map<String, dynamic>),
    discount: json['discount'] == null
        ? null
        : Discount.fromJson(json['discount'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'sub_category_id': instance.subCategoryId,
      'cover': instance.cover,
      'name': instance.name,
      'caption': instance.caption,
      'price': instance.price,
      'tag': instance.tag,
      'link': instance.link,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'delivery_type': instance.deliveryType?.toJson(),
      'discount': instance.discount?.toJson(),
    };
