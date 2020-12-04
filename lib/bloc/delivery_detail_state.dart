part of 'delivery_detail_cubit.dart';

abstract class DeliveryDetailState extends Equatable {
  final List<DeliveryDetail> deliveryDetails;
  const DeliveryDetailState(this.deliveryDetails);
}

class DeliveryDetailInitial extends DeliveryDetailState {
  DeliveryDetailInitial(List<DeliveryDetail> deliveryDetails) : super(deliveryDetails);

  @override
  List<Object> get props => [];
}

class DeliveryDetailLoading extends DeliveryDetailState {
  DeliveryDetailLoading(List<DeliveryDetail> deliveryDetails) : super(deliveryDetails);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeliveryDetailComplete extends DeliveryDetailState {
  final List<DeliveryDetail> deliveryDetails;
  DeliveryDetailComplete(this.deliveryDetails) : super(deliveryDetails);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeliveryDetailError extends DeliveryDetailState {
  DeliveryDetailError(List<DeliveryDetail> deliveryDetails) : super(deliveryDetails);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
