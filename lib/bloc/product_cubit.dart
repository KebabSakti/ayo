import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit()
      : super(ProductInitial(ProductPaginate(
          pagination: Pagination(),
          products: List<Product>(),
        )));

  final _repository = locator<Repository>();

  void fetchProduct({
    @required UserData user,
    @required QueryModel query,
    String url,
  }) async {
    emit(ProductLoading(state.productPaginate));

    var response = await _repository.fetchProduct(user: user, query: query);
    if (response is! DioError) {
      emit(ProductCompleted(response));
    } else {
      emit(ProductError());
    }
  }

  void fetchMoreProduct({
    @required UserData user,
    @required QueryModel query,
  }) async {
    emit(ProductPagingLoading(state.productPaginate));

    var products = state.productPaginate.products;

    var response = await _repository.fetchProduct(
      user: user,
      query: query,
      page: state.productPaginate.pagination.currentPage + 1,
    );

    if (response is! DioError) {
      products.addAll(response.products);

      emit(ProductCompleted(ProductPaginate(
          products: products, pagination: response.pagination)));
    } else {
      emit(ProductError());
    }
  }
}
