part of 'intro_cubit.dart';

abstract class IntroState extends Equatable {
  const IntroState();
}

class IntroInitial extends IntroState {
  @override
  List<Object> get props => [];
}

class IntroDataLoading extends IntroState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class IntroDataDownloaded extends IntroState {
  final List<IntroData> intros;
  const IntroDataDownloaded(this.intros);

  @override
  // TODO: implement props
  List<Object> get props => [intros];
}

class IntroDataError extends IntroState {
  final String message;
  IntroDataError({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
