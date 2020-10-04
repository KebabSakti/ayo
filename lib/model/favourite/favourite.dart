import 'package:json_annotation/json_annotation.dart';

part 'favourite.g.dart';

@JsonSerializable(nullable: true)
class Favourite {
  Favourite({
    this.id,
    this.favouriteId,
    this.userId,
    this.productId,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'favourite_id')
  final String favouriteId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Favourite copyWith({
    int id,
    String favouriteId,
    String userId,
    String productId,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Favourite(
        id: id ?? this.id,
        favouriteId: favouriteId ?? this.favouriteId,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Favourite.fromJson(Map<String, dynamic> json) =>
      _$FavouriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavouriteToJson(this);
}
