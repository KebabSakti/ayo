import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'product_rekomendasi_state.dart';

class ProductRekomendasiCubit extends Cubit<ProductRekomendasiState> {
  ProductRekomendasiCubit()
      : super(ProductRekomendasiInitial(ProductPaginate(
          products: [],
          pagination: Pagination(),
        )));

  final Repository repository = locator<Repository>();

  void fetchProduct({
    @required UserData user,
    @required QueryModel query,
    String url,
  }) async {
    emit(ProductRekomendasiLoading(state.productPaginate));

    var response = await repository.fetchProduct(user: user, query: query);

    if (response is! DioError) {
      emit(ProductRekomendasiCompleted(response));
    } else {
      emit(ProductRekomendasiError(ProductPaginate(
        products: [],
        pagination: Pagination(),
      )));
    }
  }

  void fetchMoreProduct({
    @required UserData user,
    @required QueryModel query,
  }) async {
    emit(ProductRekomendasiPagingLoading(state.productPaginate));

    var products = state.productPaginate.products;

    var response = await repository.fetchProduct(
      user: user,
      query: query,
      page: state.productPaginate.pagination.currentPage + 1,
    );

    if (response is! DioError) {
      products.addAll(response.products);

      emit(ProductRekomendasiCompleted(ProductPaginate(
          products: products, pagination: response.pagination)));
    } else {
      emit(ProductRekomendasiError(ProductPaginate(
        products: [],
        pagination: Pagination(),
      )));
    }
  }
}
