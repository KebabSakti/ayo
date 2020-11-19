// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search(
    id: json['id'] as int,
    searchId: json['search_id'] as String,
    userId: json['user_id'] as String,
    keyword: json['keyword'] as String,
    hits: json['hits'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'id': instance.id,
      'search_id': instance.searchId,
      'user_id': instance.userId,
      'keyword': instance.keyword,
      'hits': instance.hits,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
