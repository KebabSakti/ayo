import 'package:json_annotation/json_annotation.dart';

part 'payment_status_model.g.dart';

@JsonSerializable()
class PaymentStatus {
  PaymentStatus({
    this.id,
    this.paymentStatusId,
    this.saleId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'payment_status_id')
  final String paymentStatusId;
  @JsonKey(name: 'sale_id')
  final String saleId;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PaymentStatus copyWith({
    int id,
    String paymentStatusId,
    String saleId,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      PaymentStatus(
        id: id ?? this.id,
        paymentStatusId: paymentStatusId ?? this.paymentStatusId,
        saleId: saleId ?? this.saleId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PaymentStatus.fromJson(Map<String, dynamic> json) => _$PaymentStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatusToJson(this);
}
