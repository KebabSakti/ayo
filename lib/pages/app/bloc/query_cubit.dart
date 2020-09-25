import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/query/sorting.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'query_state.dart';

class QueryCubit extends Cubit<QueryState> {
  QueryCubit()
      : super(QueryInitial(Query(
          keyword: '',
          sorting: Sorting(date: 1),
          filter: Filter(),
        )));

  void setQuery(Query query) {
    emit(QueryLoading(state.query));
    emit(QueryCompleted(query));
  }
}
