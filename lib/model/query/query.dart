import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/sorting.dart';

class QueryModel {
  final Filter filter;
  final Sorting sorting;

  QueryModel({this.filter, this.sorting});

  QueryModel copyWith({Filter filter, Sorting sorting}) {
    return QueryModel(
      filter: filter ?? this.filter,
      sorting: sorting ?? this.sorting,
    );
  }
}
