part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchComplete extends SearchState {
  final List<Search> searches;

  SearchComplete(this.searches) : super();

  @override
  // TODO: implement props
  List<Object> get props => [searches];
}

class SearchError extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
