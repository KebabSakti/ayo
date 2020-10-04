import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_terlaris_home_state.dart';

class ProductTerlarisHomeCubit extends Cubit<ProductTerlarisHomeState> {
  ProductTerlarisHomeCubit()
      : super(ProductTerlarisHomeInitial(ProductPaginate(
          products: [],
          pagination: Pagination(),
        )));

  final Repository repository = locator<Repository>();

  void fetchProduct({
    @required UserData user,
    @required QueryModel query,
    String url,
  }) async {
    emit(ProductTerlarisHomeLoading(state.productPaginate));

    var response = await repository.fetchProduct(user: user, query: query);

    if (response is! DioError) {
      emit(ProductTerlarisHomeComplete(response));
    } else {
      emit(ProductTerlarisHomeError(ProductPaginate(
        products: [],
        pagination: Pagination(),
      )));
    }
  }
}
