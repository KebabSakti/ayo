part of 'order_summary_cubit.dart';

abstract class OrderSummaryState extends Equatable {
  final OrderSummary orderSummary;
  const OrderSummaryState(this.orderSummary);
}

class OrderSummaryInitial extends OrderSummaryState {
  OrderSummaryInitial(OrderSummary orderSummary) : super(orderSummary);

  @override
  List<Object> get props => [];
}

class OrderSummaryLoading extends OrderSummaryState {
  OrderSummaryLoading(OrderSummary orderSummary) : super(orderSummary);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OrderSummaryCompleted extends OrderSummaryState {
  final OrderSummary orderSummary;
  OrderSummaryCompleted(this.orderSummary) : super(orderSummary);

  @override
  // TODO: implement props
  List<Object> get props => [orderSummary];
}

class OrderSummaryFailed extends OrderSummaryState {
  OrderSummaryFailed(OrderSummary orderSummary) : super(orderSummary);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
