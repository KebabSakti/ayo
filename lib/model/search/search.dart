import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
class Search {
  Search({
    this.id,
    this.searchId,
    this.userId,
    this.keyword,
    this.hits,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'search_id')
  final String searchId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String keyword;
  final int hits;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Search copyWith({
    int id,
    String searchId,
    String userId,
    String keyword,
    int hits,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Search(
        id: id ?? this.id,
        searchId: searchId ?? this.searchId,
        userId: userId ?? this.userId,
        keyword: keyword ?? this.keyword,
        hits: hits ?? this.hits,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
