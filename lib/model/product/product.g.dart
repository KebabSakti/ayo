// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    productId: json['product_id'] as String,
    subCategoryId: json['sub_category_id'] as String,
    deliveryTypeId: json['delivery_type_id'] as String,
    cover: json['cover'] as String,
    name: json['name'] as String,
    caption: json['caption'] as String,
    price: Product._fromDouble(json['price'] as String),
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
    ratingWeight: json['rating_weight'] == null
        ? null
        : RatingWeight.fromJson(json['rating_weight'] as Map<String, dynamic>),
    unit: json['unit'] == null
        ? null
        : Unit.fromJson(json['unit'] as Map<String, dynamic>),
    favourite: json['favourite'] == null
        ? null
        : Favourite.fromJson(json['favourite'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'sub_category_id': instance.subCategoryId,
      'delivery_type_id': instance.deliveryTypeId,
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
      'rating_weight': instance.ratingWeight?.toJson(),
      'unit': instance.unit?.toJson(),
      'favourite': instance.favourite?.toJson(),
    };
