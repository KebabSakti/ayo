import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
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

    var carts = await _repository.addCart(user: user, cartData: cartData);
    if (carts is! DioError) {
      emit(CartComplete(carts));
    } else {
      emit(CartError(state.carts));
    }
  }

  void updateCart({@required List<Cart> carts}) {
    emit(CartUpdateLoading(state.carts));
    emit(CartComplete(carts));
  }

  void removeCart({@required UserData user, @required String productId}) async {
    emit(CartRemoveLoading(state.carts));

    var carts = await _repository.removeCart(user: user, productId: productId);
    if (carts is! DioError) {
      carts = state.carts.where((e) => e.product.productId != productId).toList();
      emit(CartComplete(carts));
    } else {
      emit(CartError(state.carts));
    }
  }

  void uploadCart({@required UserData user, @required List<Cart> carts}) async {
    emit(CartUploadLoading(state.carts));

    var myCarts = await _repository.uploadCart(user: user, carts: carts);
    if (myCarts is! DioError) {
      emit(CartUploadComplete(myCarts));
      emit(CartComplete(myCarts));
    } else {
      emit(CartError(state.carts));
    }
  }
}
