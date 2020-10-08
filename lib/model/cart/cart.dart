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
    this.checked,
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
  final int checked;
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

  static double _fromDouble(String value) => value == null ? null : double.parse(value);

  Cart copyWith({
    int id,
    String cartId,
    String userId,
    String productId,
    int checked,
    double price,
    int qty,
    double total,
    DateTime createdAt,
    DateTime updatedAt,
    Product product,
  }) {
    return Cart(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      checked: checked ?? this.checked,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}
