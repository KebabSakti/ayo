import 'package:ayo/model/cart/cart.dart';

class CartItemModel {
  final bool checked;
  final Cart cart;

  CartItemModel({this.checked, this.cart});

  CartItemModel copyWith({bool checked, Cart cart}) {
    return CartItemModel(
      checked: checked ?? this.checked,
      cart: cart ?? this.cart,
    );
  }
}
