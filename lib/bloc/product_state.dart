part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  final ProductPaginate productPaginate;
  const ProductState(this.productPaginate);
}

class ProductInitial extends ProductState {
  ProductInitial(ProductPaginate productPaginate) : super(productPaginate);

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {
  ProductLoading(ProductPaginate productPaginate) : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductCompleted extends ProductState {
  final ProductPaginate productPaginate;
  ProductCompleted(this.productPaginate) : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [productPaginate];
}

class ProductError extends ProductState {
  final String message;
  ProductError({this.message})
      : super(ProductPaginate(
          pagination: Pagination(),
          products: List<Product>(),
        ));

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductPagingLoading extends ProductState {
  ProductPagingLoading(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductPagingCompleted extends ProductState {
  final ProductPaginate productPaginate;
  ProductPagingCompleted(this.productPaginate) : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [productPaginate];
}

class ProductPaginateError extends ProductState {
  final String message;
  ProductPaginateError({this.message})
      : super(ProductPaginate(
          pagination: Pagination(),
          products: List<Product>(),
        ));

  @override
  // TODO: implement props
  List<Object> get props => [];
}
