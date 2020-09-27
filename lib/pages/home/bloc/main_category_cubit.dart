import 'package:ayo/model/main_category/main_category_model.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'main_category_state.dart';

class MainCategoryCubit extends Cubit<MainCategoryState> {
  MainCategoryCubit() : super(MainCategoryInitial([]));

  final Repository repository = locator<Repository>();

  void fetchMainCategory({@required UserData user}) async {
    emit(MainCategoryLoading(state.mainCategories));
    var mainCategories = await repository.fetchMainCategory(user: user);
    if (mainCategories is! DioError) {
      emit(MainCategoryCompleted(mainCategories));
    } else {
      emit(MainCategoryError());
    }
  }
}
