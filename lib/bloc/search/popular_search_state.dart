part of 'popular_search_cubit.dart';

abstract class PopularSearchState extends Equatable {
  final List<Search> searchs;
  const PopularSearchState(this.searchs);
}

class PopularSearchInitial extends PopularSearchState {
  PopularSearchInitial(List<Search> searchs) : super(searchs);

  @override
  List<Object> get props => [];
}

class PopularSearchLoading extends PopularSearchState {
  PopularSearchLoading(List<Search> searchs) : super(searchs);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PopularSearchComplete extends PopularSearchState {
  final List<Search> searchs;
  PopularSearchComplete(this.searchs) : super(searchs);

  @override
  // TODO: implement props
  List<Object> get props => [searchs];
}

class PopularSearchError extends PopularSearchState {
  PopularSearchError(List<Search> searchs) : super(searchs);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
