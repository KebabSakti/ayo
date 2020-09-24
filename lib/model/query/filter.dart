class Filter {
  final String kategoriId;
  final double priceMin;
  final double priceMax;
  final int instant;
  final int rating;
  final int view;

  Filter({this.kategoriId, this.priceMin, this.priceMax, this.instant, this.rating, this.view,});

  Filter copyWith({String kategoriId, double priceMin, double priceMax, int instant, int rating, int view}) {
    return Filter(kategoriId: kategoriId ?? this.kategoriId, priceMin: priceMin ?? this.priceMin, priceMax: priceMax ?? this.priceMax, instant: instant ?? this.instant, rating: rating ?? this.rating, view: view ?? this.view,);
  }
}

class Sorting {
  final int latest;
  final int oldest;
  final int lowest;
  final int highest;

  Sorting({this.latest, this.oldest, this.lowest, this.highest});

  Sorting copyWith(int latest, int oldest, int lowest, int highest) {
    return Sorting(latest: latest ?? this.latest, oldest: oldest ?? this.oldest, lowest: lowest ?? this.lowest, highest: highest ?? this.highest,);
  }
}