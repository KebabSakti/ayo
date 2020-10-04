class Sorting {
  final String sorting;

  Sorting({
    this.sorting,
  });

  Sorting copyWith({String sorting}) {
    return Sorting(
      sorting: sorting ?? this.sorting,
    );
  }
}
