import 'package:ayo/moor/db.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial([]));

  final Repository repository = locator<Repository>();

  void fetchBanner({String target, @required UserData user}) async {
    emit(BannerLoading(state.banners));
    var banners = await repository.fetchBanner(target: target, user: user);
    if (banners is! DioError) {
      emit(BannerCompleted(banners: banners));
    } else {
      emit(BannerError());
    }
  }
}
