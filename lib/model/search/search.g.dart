// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search(
    keyword: json['keyword'] as String,
    hits: json['hits'] as int,
  );
}

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'keyword': instance.keyword,
      'hits': instance.hits,
    };
