// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Viewer _$ViewerFromJson(Map<String, dynamic> json) {
  return Viewer(
    id: json['id'] as int,
    viewerId: json['viewer_id'] as String,
    relationId: json['relation_id'] as String,
    userId: json['user_id'] as String,
    view: json['view'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ViewerToJson(Viewer instance) => <String, dynamic>{
      'id': instance.id,
      'viewer_id': instance.viewerId,
      'relation_id': instance.relationId,
      'user_id': instance.userId,
      'view': instance.view,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
