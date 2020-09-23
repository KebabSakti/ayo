part of 'connection_cubit.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();
}

class ConnectionInitial extends ConnectionState {
  @override
  List<Object> get props => [];
}

class ConnectionLoading extends ConnectionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ConnectionMobile extends ConnectionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ConnectionWifi extends ConnectionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ConnectionOffline extends ConnectionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
