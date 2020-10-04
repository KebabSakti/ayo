part of 'query_cubit.dart';

abstract class QueryState extends Equatable {
  final QueryModel query;
  const QueryState(this.query);
}

class QueryInitial extends QueryState {
  QueryInitial(QueryModel query) : super(query);

  @override
  List<Object> get props => [];
}

class QueryLoading extends QueryState {
  QueryLoading(QueryModel query) : super(query);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class QueryCompleted extends QueryState {
  final QueryModel query;
  QueryCompleted(this.query) : super(query);

  @override
  // TODO: implement props
  List<Object> get props => [query];
}

class QueryError extends QueryState {
  QueryError() : super(null);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
