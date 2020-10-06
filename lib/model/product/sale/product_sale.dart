import 'package:json_annotation/json_annotation.dart';

part 'product_sale.g.dart';

@JsonSerializable(nullable: true)
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
  @JsonKey(name: 'product_sale_id')
  final String productSaleId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'qty_total')
  final int qtyTotal;
  @JsonKey(name: 'amount_total', fromJson: _fromDouble)
  final double amountTotal;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  static double _fromDouble(String value) =>
      value == null ? null : double.parse(value);

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
