part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  final List<Product> products;
  const SearchState(this.products);
}

class SearchInitial extends SearchState {
  SearchInitial(List<Product> products) : super(products);

  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  SearchLoading(List<Product> products) : super(products);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchComplete extends SearchState {
  final List<Product> products;

  SearchComplete(this.products) : super(products);

  @override
  // TODO: implement props
  List<Object> get props => [products];
}

class SearchError extends SearchState {
  SearchError(List<Product> products) : super(products);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
