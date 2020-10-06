import 'package:ayo/model/favourite/favourite.dart';
import 'package:ayo/model/product/delivery_type/delivery_type.dart';
import 'package:ayo/model/product/discount/discount.dart';
import 'package:ayo/model/product/sale/product_sale.dart';
import 'package:ayo/model/rating/rating.dart';
import 'package:ayo/model/unit/unit.dart';
import 'package:ayo/model/viewer/viewer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'sub_category_id')
  final String subCategoryId;
  @JsonKey(name: 'delivery_type_id')
  final String deliveryTypeId;
  final String cover;
  final String name;
  final String caption;
  @JsonKey(fromJson: _fromDouble)
  final double price;
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
  @JsonKey(nullable: true, name: 'rating_weight')
  final RatingWeight ratingWeight;
  final Unit unit;
  @JsonKey(nullable: true)
  final Favourite favourite;
  @JsonKey(nullable: true)
  final Viewer viewer;
  @JsonKey(nullable: true, name: 'product_sale')
  final ProductSale productSale;

  static double _fromDouble(String value) =>
      value == null ? null : double.parse(value);

  Product({
    this.productId,
    this.subCategoryId,
    this.deliveryTypeId,
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
    this.ratingWeight,
    this.unit,
    this.favourite,
    this.viewer,
    this.productSale,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
