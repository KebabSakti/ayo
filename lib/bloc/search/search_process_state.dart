part of 'search_process_cubit.dart';

abstract class SearchProcessState extends Equatable {
  const SearchProcessState();
}

class SearchProcessInitial extends SearchProcessState {
  @override
  List<Object> get props => [];
}

class SearchProcessLoading extends SearchProcessState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchProcessComplete extends SearchProcessState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchProcessError extends SearchProcessState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
