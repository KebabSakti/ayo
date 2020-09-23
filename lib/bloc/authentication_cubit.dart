import 'package:ayo/moor/db.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Repository repository;
  AuthenticationCubit(this.repository) : super(AuthenticationInitial(null));

  Future validateUser() async {
    emit(AuthenticationLoading(state.userData));
    //get logged in user
    var user = await repository.validateUser();
    if (user != null) {
      emit(AuthenticationComplete(user));
    } else {
      //get session for guest
      var response = await repository.fetchGuestUser();
      if (response is! DioError) {
        //insert user info to local db
        await repository.insertUser(response);
        emit(AuthenticationComplete(response));
      } else {
        emit(AuthenticationError(message: 'Network fail'));
      }
    }
  }
}
