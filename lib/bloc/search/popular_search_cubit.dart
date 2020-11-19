import 'package:ayo/model/search/search.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'popular_search_state.dart';

class PopularSearchCubit extends Cubit<PopularSearchState> {
  PopularSearchCubit() : super(PopularSearchInitial([]));

  final Repository _repository = locator<Repository>();

  void fetchPopularSearch({@required UserData user}) async {
    emit(PopularSearchLoading(state.searchs));

    var searchs = await _repository.fetchPopularSearch(user: user);
    if (searchs is! DioError) {
      emit(PopularSearchComplete(searchs));
    } else {
      emit(PopularSearchError(state.searchs));
    }
  }
}
