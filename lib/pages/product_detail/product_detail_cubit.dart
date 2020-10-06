import 'package:ayo/model/product/product.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial(Product()));

  final Repository _repository = locator<Repository>();

  void fetchProductDetail(
      {@required UserData userData, @required String productId}) async {
    emit(ProductDetailLoading(state.product));

    var product = await _repository.fetchProductDetail(
        user: userData, productId: productId);
    if (product is! DioError) {
      emit(ProductDetailCompleted(product));
    } else {
      emit(ProductDetailError());
    }
  }
}
