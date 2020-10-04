import 'package:json_annotation/json_annotation.dart';

part 'product_search.g.dart';

@JsonSerializable()
class ProductSearch {
  ProductSearch({
    this.id,
    this.productSearchId,
    this.productId,
    this.hits,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String productSearchId;
  final String productId;
  final int hits;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductSearch copyWith({
    int id,
    String productSearchId,
    String productId,
    int hits,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      ProductSearch(
        id: id ?? this.id,
        productSearchId: productSearchId ?? this.productSearchId,
        productId: productId ?? this.productId,
        hits: hits ?? this.hits,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ProductSearch.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSearchToJson(this);
}
