// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favourite _$FavouriteFromJson(Map<String, dynamic> json) {
  return Favourite(
    id: json['id'] as int,
    favouriteId: json['favourite_id'] as String,
    userId: json['user_id'] as String,
    productId: json['product_id'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$FavouriteToJson(Favourite instance) => <String, dynamic>{
      'id': instance.id,
      'favourite_id': instance.favouriteId,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
