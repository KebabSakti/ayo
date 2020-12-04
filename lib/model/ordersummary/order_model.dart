import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class Order {
  Order({
    this.id,
    this.saleId,
    this.customerId,
    this.code,
    this.voucher,
    this.voucherAmount,
    this.subTotal,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'sale_id')
  final String saleId;
  @JsonKey(name: 'customer_id')
  final String customerId;
  final int code;
  @JsonKey(nullable: true)
  final String voucher;
  @JsonKey(name: 'voucher_amount', nullable: true)
  final int voucherAmount;
  @JsonKey(name: 'sub_total')
  final int subTotal;
  final int total;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Order copyWith({
    int id,
    String saleId,
    String customerId,
    int code,
    String voucher,
    int voucherAmount,
    int subTotal,
    int total,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Order(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        customerId: customerId ?? this.customerId,
        code: code ?? this.code,
        voucher: voucher ?? this.voucher,
        voucherAmount: voucherAmount ?? this.voucherAmount,
        subTotal: subTotal ?? this.subTotal,
        total: total ?? this.total,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
