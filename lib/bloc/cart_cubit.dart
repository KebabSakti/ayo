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

  void removeCart({@required UserData user, @required String productId}) async {
    emit(CartRemoveLoading(state.carts));
    var carts = await _repository.removeCart(user: user, productId: productId);
    if (carts is! DioError) {
      emit(CartComplete(carts));
    } else {
      emit(CartError(state.carts));
    }
  }
}
