import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable(nullable: true)
class ProductImage {
  final String image;

  ProductImage({this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}
