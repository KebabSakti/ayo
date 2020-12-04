import 'package:json_annotation/json_annotation.dart';

part 'order_status_model.g.dart';

@JsonSerializable()
class OrderStatus {
  OrderStatus({
    this.id,
    this.saleStatusId,
    this.saleId,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'sale_status_id')
  final String saleStatusId;
  @JsonKey(name: 'sale_id')
  final String saleId;
  final String status;
  @JsonKey(nullable: true)
  final String note;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  OrderStatus copyWith({
    int id,
    String saleStatusId,
    String saleId,
    String status,
    String note,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      OrderStatus(
        id: id ?? this.id,
        saleStatusId: saleStatusId ?? this.saleStatusId,
        saleId: saleId ?? this.saleId,
        status: status ?? this.status,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory OrderStatus.fromJson(Map<String, dynamic> json) => _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}
