import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'product_rekomendasi_state.dart';

class ProductRekomendasiCubit extends Cubit<ProductRekomendasiState> {
  final Repository repository;
  ProductRekomendasiCubit(this.repository)
      : super(ProductRekomendasiInitial(ProductPaginate(
          products: [],
          pagination: Pagination(),
        )));

  void fetchProduct({
    @required UserData user,
    @required Query query,
  }) async {
    emit(ProductRekomendasiLoading(state.productPaginate));

    var response =
        await repository.fetchProductTerlarisKategori(user: user, query: query);
    if (response is! DioError) {
      emit(ProductRekomendasiCompleted(response));
    } else {
      emit(ProductRekomendasiError());
    }
  }
}
