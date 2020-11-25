import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'search_process_state.dart';

class SearchProcessCubit extends Cubit<SearchProcessState> {
  SearchProcessCubit() : super(SearchProcessInitial());

  Repository _repository = locator<Repository>();

  void saveSearchKeyword({@required UserData userData, @required String keyword}) async {
    emit(SearchProcessLoading());

    var response = await _repository.saveSearchKeyword(user: userData, keyword: keyword);
    if (response is! DioError) {
      emit(SearchProcessComplete());
    } else {
      emit(SearchProcessError());
    }
  }

  void clearSearchKeyword({@required UserData userData}) async {
    emit(SearchProcessLoading());

    var response = await _repository.clearSearchKeyword(user: userData);
    if (response is! DioError) {
      emit(SearchProcessComplete());
    } else {
      emit(SearchProcessError());
    }
  }
}
