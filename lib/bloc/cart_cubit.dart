import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:ayo/util/helper.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial(List<Cart>()));

  final Repository _repository = locator<Repository>();

  void fetchCart({@required UserData user}) async {
    emit(CartLoading(state.carts));
    var carts = await _repository.fetchCart(user: user);
    if (carts is! DioError) {
      emit(CartComplete(carts));
    } else {
      emit(CartError(state.carts));
    }
  }

  void addCart({@required UserData user, @required Cart cartData}) async {
    emit(CartAddLoading(state.carts));
    var carts = state.carts;
    if (carts.where((e) => e.productId == cartData.product.productId).toList().length == 0) {
      //add new
      carts.add(Cart(
        cartId: Helper().generateRandomId(),
        userId: user.id,
        productId: cartData.product.productId,
        checked: 1,
        price: cartData.product.price,
        qty: 1,
        total: cartData.product.price,
        product: cartData.product,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ));
    } else {
      //add qty + 1
      carts = List<Cart>.from(state.carts.map((e) {
        if (e.product.productId == cartData.product.productId) {
          return e.copyWith(
            qty: e.qty + 1,
            total: (e.qty + 1) * e.product.price,
          );
        } else {
          return e;
        }
      }).toList());
    }

    emit(CartComplete(carts));
  }

  void updateCart({@required List<Cart> carts}) {
    emit(CartUpdateLoading(state.carts));
    emit(CartComplete(carts));
  }

  void removeCart({@required UserData user, @required String productId}) async {
    emit(CartRemoveLoading(state.carts));

    // var carts = await _repository.removeCart(user: user, productId: productId);
    // if (carts is! DioError) {
    //   emit(CartComplete(carts));
    // } else {
    //   emit(CartError(state.carts));
    // }

    var carts = state.carts.where((e) => e.product.productId != productId).toList();
    emit(CartComplete(carts));
  }

  void uploadCart({@required UserData user, @required List<Cart> carts}) async {
    emit(CartUploadLoading(state.carts));

    var myCarts = await _repository.uploadCart(user: user, carts: carts);
    if (myCarts is! DioError) {
      emit(CartComplete(myCarts));
    } else {
      emit(CartError(state.carts));
    }
  }
}
