import 'package:ayo/model/ordersummary/courier_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_detail_model.g.dart';

@JsonSerializable()
class DeliveryDetail {
  DeliveryDetail({
    this.id,
    this.deliveryDetailId,
    this.saleId,
    this.customerId,
    this.courierId,
    this.placeId,
    this.name,
    this.phone,
    this.address,
    this.distance,
    this.eta,
    this.fee,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.couriers,
  });

  final int id;
  @JsonKey(name: 'delivery_detail_id')
  final String deliveryDetailId;
  @JsonKey(name: 'sale_id')
  final String saleId;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'courier_id')
  final String courierId;
  final String placeId;
  final String name;
  final String phone;
  final String address;
  final int distance;
  final int eta;
  final int fee;
  final String note;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<Courier> couriers;

  DeliveryDetail copyWith({
    int id,
    String deliveryDetailId,
    String saleId,
    String customerId,
    String courierId,
    String placeId,
    String name,
    String phone,
    String address,
    int distance,
    int eta,
    int fee,
    String note,
    DateTime createdAt,
    DateTime updatedAt,
    List<Courier> couriers,
  }) =>
      DeliveryDetail(
        id: id ?? this.id,
        deliveryDetailId: deliveryDetailId ?? this.deliveryDetailId,
        saleId: saleId ?? this.saleId,
        customerId: customerId ?? this.customerId,
        courierId: courierId ?? this.courierId,
        placeId: placeId ?? this.placeId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        distance: distance ?? this.distance,
        eta: eta ?? this.eta,
        fee: fee ?? this.fee,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        couriers: couriers ?? this.couriers,
      );

  factory DeliveryDetail.fromJson(Map<String, dynamic> json) => _$DeliveryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDetailToJson(this);
}
