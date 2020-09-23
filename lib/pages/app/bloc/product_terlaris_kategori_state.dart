part of 'product_terlaris_kategori_cubit.dart';

abstract class ProductTerlarisKategoriState extends Equatable {
  final List<Product> products;
  const ProductTerlarisKategoriState(this.products);
}

class ProductTerlarisKategoriInitial extends ProductTerlarisKategoriState {
  ProductTerlarisKategoriInitial(List<Product> products) : super(products);

  @override
  List<Object> get props => [];
}

class ProductTerlarisKategoriLoading extends ProductTerlarisKategoriState {
  ProductTerlarisKategoriLoading(List<Product> products) : super(products);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductTerlarisKategoriCompleted extends ProductTerlarisKategoriState {
  final List<Product> products;
  ProductTerlarisKategoriCompleted(this.products) : super(products);

  @override
  // TODO: implement props
  List<Object> get props => [products];
}

class ProductTerlarisKategoriError extends ProductTerlarisKategoriState {
  final String message;
  ProductTerlarisKategoriError({this.message}) : super(null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
