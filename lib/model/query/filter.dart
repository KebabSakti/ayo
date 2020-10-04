class Filter {
  final String subCategoryId;
  final String mainCategoryId;
  final String keyword;
  final int terlaris;
  final int diskon;
  final int search;
  final int view;
  final int rating;
  final String pengiriman;
  final double hargaMin;
  final double hargaMax;
  final int favourite;

  Filter({
    this.subCategoryId,
    this.mainCategoryId,
    this.keyword,
    this.terlaris,
    this.diskon,
    this.search,
    this.view,
    this.rating,
    this.pengiriman,
    this.hargaMin,
    this.hargaMax,
    this.favourite,
  });

  Filter copyWith({
    String subCategoryId,
    String mainCategoryId,
    String keyword,
    int terlaris,
    int diskon,
    int search,
    int view,
    int rating,
    String pengiriman,
    double hargaMin,
    double hargaMax,
    int favourite,
  }) {
    return Filter(
      subCategoryId: subCategoryId ?? this.subCategoryId,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      keyword: keyword ?? this.keyword,
      terlaris: terlaris ?? this.terlaris,
      diskon: diskon ?? this.diskon,
      search: search ?? this.search,
      view: view ?? this.view,
      rating: rating ?? this.rating,
      pengiriman: pengiriman ?? this.pengiriman,
      hargaMin: hargaMin ?? this.hargaMin,
      hargaMax: hargaMax ?? this.hargaMax,
      favourite: favourite ?? this.favourite,
    );
  }
}
