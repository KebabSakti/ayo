import 'package:ayo/model/ordersummary/order_summary.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_summary_state.dart';

class OrderSummaryCubit extends Cubit<OrderSummaryState> {
  OrderSummaryCubit() : super(OrderSummaryInitial(OrderSummary()));

  final Repository _repository = locator<Repository>();

  void fetchOrderSummary() {
    emit(OrderSummaryLoading(state.orderSummary));
    emit(OrderSummaryCompleted(state.orderSummary));
  }

  void addOrderSummary(OrderSummary orderSummary) {
    emit(OrderSummaryLoading(state.orderSummary));

    var data = OrderSummary(
      order: orderSummary.order ?? state.orderSummary.order,
      orderDetails: orderSummary.orderDetails ?? state.orderSummary.orderDetails,
      deliveryDetails: orderSummary.deliveryDetails ?? state.orderSummary.deliveryDetails,
      paymentDetail: orderSummary.paymentDetail ?? state.orderSummary.paymentDetail,
    );

    emit(OrderSummaryCompleted(data));
  }
}
