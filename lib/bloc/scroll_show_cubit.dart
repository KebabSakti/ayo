import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scroll_show_state.dart';

class ScrollShowCubit extends Cubit<ScrollShowState> {
  ScrollShowCubit() : super(ScrollShowInitial(null, null));

  void getScrollPosition(String tag, double position) {
    emit(ScrollShowLoading(state.tag, state.position));
    emit(ScrollShowComplete(tag, position));
  }
}
