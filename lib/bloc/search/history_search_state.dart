part of 'history_search_cubit.dart';

abstract class HistorySearchState extends Equatable {
  const HistorySearchState();
}

class HistorySearchInitial extends HistorySearchState {
  @override
  List<Object> get props => [];
}

class HistorySearchLoading extends HistorySearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistorySearchComplete extends HistorySearchState {
  final List<Search> searches;

  HistorySearchComplete(this.searches) : super();

  @override
  // TODO: implement props
  List<Object> get props => [searches];
}

class HistorySearchError extends HistorySearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
