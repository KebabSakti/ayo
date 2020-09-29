import 'package:json_annotation/json_annotation.dart';

part 'main_category_model.g.dart';

@JsonSerializable(nullable: false)
class MainCategoryModel {
  @JsonKey(name: 'main_category_id')
  final String categoryId;
  @JsonKey(name: 'delivery_type_id')
  final String deliveryTypeId;
  final String title;
  @JsonKey(nullable: true)
  final String caption;
  final int active;
  @JsonKey(nullable: true)
  final String color;
  final String image;
  @JsonKey(name: 'created_at', nullable: true)
  final String createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  final String updatedAt;

  MainCategoryModel({
    this.categoryId,
    this.deliveryTypeId,
    this.title,
    this.caption,
    this.active,
    this.color,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoryModelToJson(this);
}
