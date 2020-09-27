import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit() : super(IntroInitial());

  final Repository repository = locator<Repository>();

  Future<dynamic> _downloadIntroData(UserData user) async {
    try {
      //fetch intro data
      var response = await repository.downloadIntroData(user);
      if (response is! DioError) {
        // if (response.length > 0) {
        //   response?.forEach((item) async {
        //     await repository.insertIntroData(item);
        //   });
        // }

        return response;
      } else {
        throw DioError();
      }
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> _authUser(BuildContext context) async {
    try {
      var authbloc = BlocProvider.of<AuthenticationCubit>(context);
      var user = await repository.validateUser();
      if (user != null) {
        authbloc.emit(AuthenticationComplete(user));
        return user;
      } else {
        //get session for guest
        var response = await repository.fetchGuestUser();
        if (response is! DioError) {
          //insert user info to local db
          await repository.insertUser(response);
          authbloc.emit(AuthenticationComplete(response));
          return response;
        } else {
          throw DioError();
        }
      }
    } on DioError catch (error) {
      return error;
    }
  }

  Future initIntro(BuildContext context) async {
    emit(IntroDataLoading());
    var user = await _authUser(context);
    if (user is! DioError) {
      //download intro
      var intros = await _downloadIntroData(user);
      if (intros is! DioError) {
        emit(IntroDataDownloaded(intros));
      } else {
        emit(IntroDataError());
      }
    } else {
      emit(IntroDataError());
    }
  }
}
