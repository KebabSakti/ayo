part of 'navigation_cubit.dart';

abstract class NavigationState extends Equatable {
  final int index;
  const NavigationState(this.index);
}

class NavigationInitial extends NavigationState {
  NavigationInitial(int index) : super(index);

  @override
  List<Object> get props => [];
}

class NavigationLoading extends NavigationState {
  NavigationLoading(int index) : super(index);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NavigationLoaded extends NavigationState {
  NavigationLoaded(int index) : super(index);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
