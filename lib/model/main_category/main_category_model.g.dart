// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainCategoryModel _$MainCategoryModelFromJson(Map<String, dynamic> json) {
  return MainCategoryModel(
    categoryId: json['category_id'] as String,
    deliveryTypeId: json['delivery_type_id'] as String,
    title: json['title'] as String,
    caption: json['caption'] as String,
    active: json['active'] as int,
    color: json['color'] as String,
    image: json['image'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$MainCategoryModelToJson(MainCategoryModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'delivery_type_id': instance.deliveryTypeId,
      'title': instance.title,
      'caption': instance.caption,
      'active': instance.active,
      'color': instance.color,
      'image': instance.image,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
