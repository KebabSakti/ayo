import 'package:ayo/model/search/search.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'history_search_state.dart';

class HistorySearchCubit extends Cubit<HistorySearchState> {
  HistorySearchCubit() : super(HistorySearchInitial());

  final Repository _repository = locator<Repository>();

  void fetchSearchHistory({@required UserData user}) async {
    emit(HistorySearchLoading());

    var datas = await _repository.fetchHistorySearch(user: user);
    if (datas is! DioError) {
      emit(HistorySearchComplete(datas));
    } else {
      emit(HistorySearchError());
    }
  }
}
