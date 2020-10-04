import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(nullable: true)
class RatingWeight {
  @JsonKey(name: 'rating_weight_id')
  final String ratingWeightId;
  @JsonKey(name: 'relation_id')
  final String relationId;
  final int one;
  final int two;
  final int three;
  final int four;
  final int five;
  @JsonKey(name: 'total_vote')
  final int totalVote;
  @JsonKey(fromJson: _fromDouble)
  final double rating;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  static double _fromDouble(String value) =>
      value == null ? null : double.parse(value);

  RatingWeight({
    this.ratingWeightId,
    this.relationId,
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.totalVote,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory RatingWeight.fromJson(Map<String, dynamic> json) =>
      _$RatingWeightFromJson(json);

  Map<String, dynamic> toJson() => _$RatingWeightToJson(this);
}
