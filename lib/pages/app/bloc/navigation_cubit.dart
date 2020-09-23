import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial(0));

  void loadPage(int index) {
    emit(NavigationLoading(state.index));
    emit(NavigationLoaded(index));
  }
}
