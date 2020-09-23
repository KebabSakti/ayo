part of 'scroll_position_cubit.dart';

abstract class ScrollPositionState extends Equatable {
  final Map<String, double> scrollPosition;
  const ScrollPositionState(this.scrollPosition);
}

class ScrollPositionInitial extends ScrollPositionState {
  ScrollPositionInitial(Map<String, double> scrollPosition)
      : super(scrollPosition);

  @override
  List<Object> get props => [];
}

class ScrollPositionLoading extends ScrollPositionState {
  ScrollPositionLoading(Map<String, double> scrollPosition)
      : super(scrollPosition);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
