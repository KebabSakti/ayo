import 'package:ayo/model/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetail {
  OrderDetail({
    this.id,
    this.saleDetailId,
    this.saleId,
    this.productId,
    this.qty,
    this.note,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  final int id;
  @JsonKey(name: 'sale_detail_id')
  final String saleDetailId;
  @JsonKey(name: 'sale_id')
  final String saleId;
  @JsonKey(name: 'product_id')
  final String productId;
  final int qty;
  final String note;
  final double total;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final Product product;

  OrderDetail copyWith({
    int id,
    String saleDetailId,
    String saleId,
    String productId,
    int qty,
    String note,
    double total,
    DateTime createdAt,
    DateTime updatedAt,
    Product product,
  }) =>
      OrderDetail(
        id: id ?? this.id,
        saleDetailId: saleDetailId ?? this.saleDetailId,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        qty: qty ?? this.qty,
        note: note ?? this.note,
        total: total ?? this.total,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        product: product ?? this.product,
      );

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
