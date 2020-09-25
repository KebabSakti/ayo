part of 'query_cubit.dart';

abstract class QueryState extends Equatable {
  final Query query;
  const QueryState(this.query);
}

class QueryInitial extends QueryState {
  QueryInitial(query) : super(query);

  @override
  List<Object> get props => [];
}

class QueryLoading extends QueryState {
  QueryLoading(Query query) : super(query);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class QueryCompleted extends QueryState {
  final Query query;
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
