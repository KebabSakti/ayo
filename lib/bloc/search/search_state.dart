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
  final List<Product> products;

  SearchComplete(this.products) : super();

  @override
  // TODO: implement props
  List<Object> get props => [products];
}

class SearchError extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PopularSearchLoading extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PopularSearchComplete extends SearchState {
  final List<Search> searchs;
  PopularSearchComplete(this.searchs) : super();

  @override
  // TODO: implement props
  List<Object> get props => [searchs];
}

class PopularSearchError extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
