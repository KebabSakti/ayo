// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
    id: json['id'] as int,
    subCategoryId: json['sub_category_id'] as String,
    mainCategoryId: json['main_category_id'] as String,
    title: json['title'] as String,
    caption: json['caption'] as String,
    image: json['image'] as String,
    color: json['color'] as String,
    link: json['link'] as String,
    active: json['active'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sub_category_id': instance.subCategoryId,
      'main_category_id': instance.mainCategoryId,
      'title': instance.title,
      'caption': instance.caption,
      'image': instance.image,
      'color': instance.color,
      'link': instance.link,
      'active': instance.active,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
