import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
class Search {
  Search({
    this.keyword,
    this.hits,
    this.image,
  });

  final String keyword;
  final int hits;
  @JsonKey(nullable: true)
  final String image;

  Search copyWith({
    String keyword,
    int hits,
    String image,
  }) =>
      Search(
        keyword: keyword ?? this.keyword,
        hits: hits ?? this.hits,
        image: image ?? this.image,
      );

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
