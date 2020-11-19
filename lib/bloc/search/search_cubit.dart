import 'package:ayo/model/product/product.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial([]));

  Repository _repository = locator<Repository>();

  void searchByKeyword({@required UserData user, @required String keyword}) async {
    emit(SearchLoading(state.products));

    var datas = await _repository.searchByKeyword(user: user, keyword: keyword);
    if (datas is! DioError) {
      if (keyword.length > 0)
        emit(SearchComplete(datas));
      else
        emit(SearchError(state.products));
    } else {
      emit(SearchError(state.products));
    }
  }
}
