part of 'product_terlaris_home_cubit.dart';

abstract class ProductTerlarisHomeState extends Equatable {
  final ProductPaginate productPaginate;
  const ProductTerlarisHomeState(this.productPaginate);
}

class ProductTerlarisHomeInitial extends ProductTerlarisHomeState {
  ProductTerlarisHomeInitial(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  List<Object> get props => [];
}

class ProductTerlarisHomeLoading extends ProductTerlarisHomeState {
  ProductTerlarisHomeLoading(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductTerlarisHomeComplete extends ProductTerlarisHomeState {
  final ProductPaginate productPaginate;
  ProductTerlarisHomeComplete(this.productPaginate) : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [productPaginate];
}

class ProductTerlarisHomeError extends ProductTerlarisHomeState {
  ProductTerlarisHomeError(ProductPaginate productPaginate)
      : super(productPaginate);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
