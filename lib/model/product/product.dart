import 'package:ayo/model/product/delivery_type/delivery_type.dart';
import 'package:ayo/model/product/discount/discount.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'sub_category_id')
  final String subCategoryId;
  final String cover;
  final String name;
  final String caption;
  final String price;
  @JsonKey(nullable: true)
  final String tag;
  @JsonKey(nullable: true)
  final String link;
  final int active;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'delivery_type')
  final DeliveryType deliveryType;
  @JsonKey(nullable: true)
  final Discount discount;

  Product({
    this.productId,
    this.subCategoryId,
    this.cover,
    this.name,
    this.caption,
    this.price,
    this.tag,
    this.link,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.deliveryType,
    this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
