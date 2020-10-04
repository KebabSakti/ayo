// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingWeight _$RatingWeightFromJson(Map<String, dynamic> json) {
  return RatingWeight(
    ratingWeightId: json['rating_weight_id'] as String,
    relationId: json['relation_id'] as String,
    one: json['one'] as int,
    two: json['two'] as int,
    three: json['three'] as int,
    four: json['four'] as int,
    five: json['five'] as int,
    totalVote: json['total_vote'] as int,
    rating: RatingWeight._fromDouble(json['rating'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$RatingWeightToJson(RatingWeight instance) =>
    <String, dynamic>{
      'rating_weight_id': instance.ratingWeightId,
      'relation_id': instance.relationId,
      'one': instance.one,
      'two': instance.two,
      'three': instance.three,
      'four': instance.four,
      'five': instance.five,
      'total_vote': instance.totalVote,
      'rating': instance.rating,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
