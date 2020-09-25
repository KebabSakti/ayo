class Filter {
  final String kategoriId;
  final double priceMin;
  final double priceMax;
  final int instant;
  final int rating;

  Filter({
    this.kategoriId,
    this.priceMin,
    this.priceMax,
    this.instant,
    this.rating,
  });

  Filter copyWith({
    String kategoriId,
    double priceMin,
    double priceMax,
    int instant,
    int rating,
  }) {
    return Filter(
      kategoriId: kategoriId ?? this.kategoriId,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      instant: instant ?? this.instant,
      rating: rating ?? this.rating,
    );
  }

  String toString() {
    return 'ID: $kategoriId \nPRICE-MIN: $priceMin \nPRICE-MAX: $priceMax \nINSTANT: $instant \nRATING: $rating \n';
  }
}
