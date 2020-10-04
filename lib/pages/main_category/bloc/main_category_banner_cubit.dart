import 'package:ayo/model/banner/slide_banner.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'main_category_banner_state.dart';

class MainCategoryBannerCubit extends Cubit<MainCategoryBannerState> {
  MainCategoryBannerCubit()
      : super(MainCategoryBannerInitial(List<SlideBanner>()));

  final Repository repository = locator<Repository>();

  void fetchBanner(
      {@required String target, String id, @required UserData user}) async {
    emit(MainCategoryBannerLoading(state.banners));
    var banners =
        await repository.fetchBanner(target: target, id: id, user: user);
    if (banners is! DioError) {
      emit(MainCategoryBannerComplete(banners: banners));
    } else {
      emit(MainCategoryBannerError());
    }
  }
}
