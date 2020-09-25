// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) {
  return Pagination(
    currentPage: json['current_page'] as int,
    firstPageUrl: json['first_page_url'] as String,
    from: json['from'] as int,
    lastPage: json['last_page'] as int,
    lastPageUrl: json['last_page_url'] as String,
    nextPageUrl: json['next_page_url'] as String,
    path: json['path'] as String,
    perPage: json['per_page'] as int,
    prevPageUrl: json['prev_page_url'] as String,
    to: json['to'] as int,
    total: json['total'] as int,
  );
}

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };
