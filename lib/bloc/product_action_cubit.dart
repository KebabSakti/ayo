import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'product_action_state.dart';

class ProductActionCubit extends Cubit<ProductActionState> {
  ProductActionCubit() : super(ProductActionInitial());

  final Repository _repository = locator<Repository>();

  void toggleFavourite({@required UserData userData, @required String productId}) async {
    emit(ProductActionLoading());

    var data = await _repository.toggleFavourite(userData: userData, productId: productId);
    if (data is! DioError) {
      emit(ProductActionComplete());
    } else {
      emit(ProductActionError());
    }
  }
}
