part of 'product_action_cubit.dart';

abstract class ProductActionState extends Equatable {
  const ProductActionState();
}

class ProductActionInitial extends ProductActionState {
  @override
  List<Object> get props => [];
}

class ProductActionLoading extends ProductActionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductActionComplete extends ProductActionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProductActionError extends ProductActionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
