class Sorting {
  final int price;
  final int date;

  Sorting({
    this.price,
    this.date,
  });

  Sorting copyWith({int price, int date}) {
    return Sorting(
      price: price ?? this.price,
      date: date ?? this.date,
    );
  }
}
