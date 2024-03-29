import 'package:ayo/model/banner/slide_banner.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial(List<SlideBanner>()));

  final Repository repository = locator<Repository>();

  void fetchBanner(
      {@required String target, String id, @required UserData user}) async {
    emit(BannerLoading(state.banners));
    var banners =
        await repository.fetchBanner(target: target, id: id, user: user);
    if (banners is! DioError) {
      emit(BannerCompleted(banners: banners));
    } else {
      emit(BannerError());
    }
  }
}
