part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  final UserData userData;

  const AuthenticationState(this.userData);
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial(userData) : super(userData);

  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  AuthenticationLoading(UserData userData) : super(userData);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationComplete extends AuthenticationState {
  AuthenticationComplete(UserData userData) : super(userData);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationState {
  final String message;
  AuthenticationError({this.message}) : super(null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
