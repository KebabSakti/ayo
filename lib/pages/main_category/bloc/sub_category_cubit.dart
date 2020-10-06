import 'package:ayo/model/sub_category/sub_category.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  SubCategoryCubit() : super(SubCategoryInitial(List<SubCategory>()));

  final Repository _repository = locator<Repository>();

  void fetchSubCategories(
      {@required UserData userData, @required String mainCategoryId}) async {
    emit(SubCategoryLoading(state.subCategories));

    var subCategories = await _repository.fetchSubCategory(
        user: userData, mainCategoryId: mainCategoryId);
    if (subCategories is! DioError) {
      emit(SubCategoryCompleted(subCategories));
    } else {
      emit(SubCategoryError());
    }
  }
}
