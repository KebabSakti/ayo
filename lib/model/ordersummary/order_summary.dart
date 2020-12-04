import 'package:ayo/model/ordersummary/delivery_detail_model.dart';
import 'package:ayo/model/ordersummary/order_detail_model.dart';
import 'package:ayo/model/ordersummary/order_model.dart';
import 'package:ayo/model/ordersummary/payment_model.dart';

class OrderSummary {
  OrderSummary({
    this.order,
    this.orderDetails,
    this.deliveryDetails,
    this.paymentDetail,
  });

  final Order order;
  final List<OrderDetail> orderDetails;
  final List<DeliveryDetail> deliveryDetails;
  final PaymentDetail paymentDetail;

  OrderSummary copyWith({
    Order order,
    List<OrderDetail> orderDetails,
    List<DeliveryDetail> deliveryDetails,
    PaymentDetail paymentDetail,
  }) =>
      OrderSummary(
        order: order ?? this.order,
        orderDetails: orderDetails ?? this.orderDetails,
        deliveryDetails: deliveryDetails ?? this.deliveryDetails,
        paymentDetail: paymentDetail ?? this.paymentDetail,
      );
}
