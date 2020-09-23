import 'package:json_annotation/json_annotation.dart';

part 'discount.g.dart';

@JsonSerializable(nullable: true)
class Discount {
  @JsonKey(name: 'discount_id')
  final String discountId;
  @JsonKey(name: 'product_id')
  final String productId;
  final double amount;
  final int active;
  @JsonKey(name: 'expired_at')
  final String expiredAt;
  @JsonKey(name: 'created_at')
  final String created_at;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Discount({
    this.discountId,
    this.productId,
    this.amount,
    this.active,
    this.expiredAt,
    this.created_at,
    this.updatedAt,
  });

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}
