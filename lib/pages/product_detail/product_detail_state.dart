part of 'product_detail_cubit.dart';

abstract class ProductDetailState extends Equatable {
  final Product product;
  const ProductDetailState(this.product);
}

class ProductDetailInitial extends ProductDetailState {
  ProductDetailInitial(Product product) : super(product);

  @override
  List<Object> get props => [];
}

class ProductDetailLoading extends ProductDetailState {
  ProductDetailLoading(Product product) : super(product);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductDetailCompleted extends ProductDetailState {
  final Product product;
  ProductDetailCompleted(this.product) : super(product);

  @override
  // TODO: implement props
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError({this.message}) : super(Product());

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
