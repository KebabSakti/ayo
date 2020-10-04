import 'package:json_annotation/json_annotation.dart';

part 'product_sale.g.dart';

@JsonSerializable()
class ProductSale {
  ProductSale({
    this.id,
    this.productSaleId,
    this.productId,
    this.qtyTotal,
    this.amountTotal,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String productSaleId;
  final String productId;
  final int qtyTotal;
  final double amountTotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductSale copyWith({
    int id,
    String productSaleId,
    String productId,
    int qtyTotal,
    String amountTotal,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      ProductSale(
        id: id ?? this.id,
        productSaleId: productSaleId ?? this.productSaleId,
        productId: productId ?? this.productId,
        qtyTotal: qtyTotal ?? this.qtyTotal,
        amountTotal: amountTotal ?? this.amountTotal,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ProductSale.fromJson(Map<String, dynamic> json) =>
      _$ProductSaleFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSaleToJson(this);
}
