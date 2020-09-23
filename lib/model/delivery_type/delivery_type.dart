import 'package:json_annotation/json_annotation.dart';

part 'delivery_type.g.dart';

@JsonSerializable()
class DeliveryType {
  @JsonKey(name: 'delivery_type_id')
  final String deliveryTypeId;
  @JsonKey(nullable: true)
  final int instant;
  @JsonKey(nullable: true)
  final int day;
  @JsonKey(nullable: true, name: 'order_start')
  final DateTime orderStart;
  @JsonKey(nullable: true, name: 'order_end')
  final DateTime orderEnd;
  @JsonKey(nullable: true, name: 'delivery_start')
  final DateTime deliveryStart;
  @JsonKey(nullable: true, name: 'delivery_end')
  final DateTime deliveryEnd;
  final String caption;

  DeliveryType({
    this.deliveryTypeId,
    this.instant,
    this.day,
    this.orderStart,
    this.orderEnd,
    this.deliveryStart,
    this.deliveryEnd,
    this.caption,
  });

  factory DeliveryType.fromJson(Map<String, dynamic> json) =>
      _$DeliveryTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryTypeToJson(this);
}
