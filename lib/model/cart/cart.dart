import 'package:ayo/model/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  Cart({
    this.id,
    this.cartId,
    this.userId,
    this.productId,
    this.price,
    this.qty,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  final int id;
  @JsonKey(name: 'cart_id')
  final String cartId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(fromJson: _fromDouble)
  final double price;
  final int qty;
  @JsonKey(fromJson: _fromDouble)
  final double total;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final Product product;

  static double _fromDouble(String value) =>
      value == null ? null : double.parse(value);

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}
