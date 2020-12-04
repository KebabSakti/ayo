import 'package:ayo/model/ordersummary/delivery_detail_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'delivery_detail_state.dart';

class DeliveryDetailCubit extends Cubit<DeliveryDetailState> {
  DeliveryDetailCubit() : super(DeliveryDetailInitial([]));

  void setDeliveryDetail({@required List<DeliveryDetail> deliveryDetails}) {
    emit(DeliveryDetailLoading(state.deliveryDetails));
    emit(DeliveryDetailComplete(deliveryDetails));
  }

  void getDeliveryDetail() {
    emit(DeliveryDetailLoading(state.deliveryDetails));
    emit(DeliveryDetailComplete(state.deliveryDetails));
  }
}
