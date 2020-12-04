import 'package:ayo/model/ordersummary/payment_status_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentDetail {
  PaymentDetail({
    this.id,
    this.paymentId,
    this.saleId,
    this.paymentMethod,
    this.paymentFee,
    this.createdAt,
    this.updatedAt,
    this.paymentStatus,
  });

  final int id;
  @JsonKey(name: 'payment_id')
  final String paymentId;
  @JsonKey(name: 'sale_id')
  final String saleId;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'payment_fee')
  final int paymentFee;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'payment_status')
  final PaymentStatus paymentStatus;

  PaymentDetail copyWith({
    int id,
    String paymentId,
    String saleId,
    String paymentMethod,
    int paymentFee,
    DateTime createdAt,
    DateTime updatedAt,
    PaymentStatus paymentStatus,
  }) =>
      PaymentDetail(
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        saleId: saleId ?? this.saleId,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentFee: paymentFee ?? this.paymentFee,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        paymentStatus: paymentStatus ?? this.paymentStatus,
      );

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => _$PaymentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailToJson(this);
}
