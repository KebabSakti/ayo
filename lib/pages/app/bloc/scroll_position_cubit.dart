import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scroll_position_state.dart';

class ScrollPositionCubit extends Cubit<ScrollPositionState> {
  ScrollPositionCubit() : super(ScrollPositionInitial({}));

  void keepScrollPosition(String target, double position) {
    emit(ScrollPositionLoading(state.scrollPosition));
    emit(ScrollPositionInitial({target: position}));
  }
}
