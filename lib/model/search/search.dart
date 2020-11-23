import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
class Search {
  Search({
    this.keyword,
    this.hits,
  });

  final String keyword;
  final int hits;

  Search copyWith({
    String keyword,
    int hits,
  }) =>
      Search(
        keyword: keyword ?? this.keyword,
        hits: hits ?? this.hits,
      );

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
