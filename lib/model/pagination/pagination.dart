import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable(nullable: false)
class Pagination {
  @JsonKey(name: 'current_page', nullable: true)
  final int currentPage;
  @JsonKey(name: 'first_page_url', nullable: true)
  final String firstPageUrl;
  @JsonKey(nullable: true)
  final int from;
  @JsonKey(name: 'last_page', nullable: true)
  final int lastPage;
  @JsonKey(name: 'last_page_url', nullable: true)
  final String lastPageUrl;
  @JsonKey(name: 'next_page_url', nullable: true)
  final String nextPageUrl;
  @JsonKey(nullable: true)
  final String path;
  @JsonKey(name: 'per_page', nullable: true)
  final int perPage;
  @JsonKey(name: 'prev_page_url', nullable: true)
  final String prevPageUrl;
  @JsonKey(nullable: true)
  final int to;
  @JsonKey(nullable: true)
  final int total;

  Pagination({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
