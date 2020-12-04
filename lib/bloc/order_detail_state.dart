part of 'order_detail_cubit.dart';

abstract class OrderDetailState extends Equatable {
  final List<OrderDetail> orderDetails;
  const OrderDetailState(this.orderDetails);
}

class OrderDetailInitial extends OrderDetailState {
  OrderDetailInitial(List<OrderDetail> orderDetails) : super(orderDetails);

  @override
  List<Object> get props => [];
}

class OrderDetailLoading extends OrderDetailState {
  OrderDetailLoading(List<OrderDetail> orderDetails) : super(orderDetails);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OrderDetailComplete extends OrderDetailState {
  final List<OrderDetail> orderDetails;
  OrderDetailComplete(this.orderDetails) : super(orderDetails);

  @override
  // TODO: implement props
  List<Object> get props => [orderDetails];
}

class OrderDetailError extends OrderDetailState {
  OrderDetailError(List<OrderDetail> orderDetails) : super(orderDetails);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
