import 'package:ayo/model/ordersummary/order_detail_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(OrderDetailInitial([]));

  void setOrderDetail({@required List<OrderDetail> orderDetails}) {
    emit(OrderDetailLoading(state.orderDetails));
    emit(OrderDetailComplete(orderDetails));
  }

  void getOrderDetail() {
    emit(OrderDetailLoading(state.orderDetails));
    emit(OrderDetailComplete(state.orderDetails));
  }
}
