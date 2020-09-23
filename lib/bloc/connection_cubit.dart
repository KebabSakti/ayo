import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit() : super(ConnectionInitial());

  var connection;

  void connectionListener() async {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      emit(ConnectionLoading());

      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile) {
        emit(ConnectionMobile());
      } else if (result == ConnectivityResult.wifi) {
        emit(ConnectionWifi());
      } else if (result == ConnectivityResult.none) {
        emit(ConnectionOffline());
      }
    });
  }

  void closeConnectionListener() {
    connection.close();
  }
}
