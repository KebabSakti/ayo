part of 'scroll_show_cubit.dart';

abstract class ScrollShowState extends Equatable {
  final double position;
  final String tag;
  const ScrollShowState(this.tag, this.position);
}

class ScrollShowInitial extends ScrollShowState {
  ScrollShowInitial(String tag, double position) : super(tag, position);

  @override
  List<Object> get props => [];
}

class ScrollShowLoading extends ScrollShowState {
  ScrollShowLoading(String tag, double position) : super(tag, position);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ScrollShowComplete extends ScrollShowState {
  ScrollShowComplete(String tag, double position) : super(tag, position);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
