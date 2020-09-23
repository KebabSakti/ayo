// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slide_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlideBanner _$SlideBannerFromJson(Map<String, dynamic> json) {
  return SlideBanner(
    promoId: json['promo_id'] as String,
    mainCategoryId: json['main_category_id'] as String,
    url: json['url'] as String,
    home: json['home'] as int,
    active: json['active'] as int,
    link: json['link'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$SlideBannerToJson(SlideBanner instance) =>
    <String, dynamic>{
      'promo_id': instance.promoId,
      'main_category_id': instance.mainCategoryId,
      'url': instance.url,
      'home': instance.home,
      'active': instance.active,
      'link': instance.link,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
