part of 'product_rekomendasi_cubit.dart';

abstract class ProductRekomendasiState extends Equatable {
  final ProductPaginate productPaginate;
  const ProductRekomendasiState(this.productPaginate);
}

class ProductRekomendasiInitial extends ProductRekomendasiState {
  ProductRekomendasiInitial(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  List<Object> get props => [];
}

class ProductRekomendasiLoading extends ProductRekomendasiState {
  ProductRekomendasiLoading(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductRekomendasiCompleted extends ProductRekomendasiState {
  final ProductPaginate productPaginate;
  ProductRekomendasiCompleted(this.productPaginate) : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [productPaginate];
}

class ProductRekomendasiError extends ProductRekomendasiState {
  final String message;
  ProductRekomendasiError({this.message}) : super(null);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
