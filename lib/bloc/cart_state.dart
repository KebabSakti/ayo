part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  final List<Cart> carts;
  const CartState(this.carts);
}

class CartInitial extends CartState {
  CartInitial(List carts) : super(carts);

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  CartLoading(List carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartComplete extends CartState {
  final List<Cart> carts;
  CartComplete(this.carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [carts];
}

class CartError extends CartState {
  final String message;
  CartError(List<Cart> carts, {this.message}) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartAddLoading extends CartState {
  CartAddLoading(List<Cart> carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartRemoveLoading extends CartState {
  CartRemoveLoading(List<Cart> carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartUpdateLoading extends CartState {
  CartUpdateLoading(List<Cart> carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartUploadLoading extends CartState {
  CartUploadLoading(List<Cart> carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartUploadComplete extends CartState {
  final List<Cart> carts;
  CartUploadComplete(this.carts) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [carts];
}

class CartUploadError extends CartState {
  final String message;
  CartUploadError(List<Cart> carts, {this.message}) : super(carts);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
