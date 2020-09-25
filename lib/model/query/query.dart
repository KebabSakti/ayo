import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/sorting.dart';

class Query {
  final String keyword;
  final Filter filter;
  final Sorting sorting;

  Query({this.keyword, this.filter, this.sorting});

  Query copyWith({String keyword, Map filter, Map sorting}) {
    return Query(
      keyword: keyword ?? this.keyword,
      filter: filter ?? this.filter,
      sorting: sorting ?? this.sorting,
    );
  }

  String toString() {
    return this.keyword;
  }
}
