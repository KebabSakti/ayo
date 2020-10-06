import 'package:json_annotation/json_annotation.dart';

part 'sub_category.g.dart';

@JsonSerializable()
class SubCategory {
  SubCategory({
    this.id,
    this.subCategoryId,
    this.mainCategoryId,
    this.title,
    this.caption,
    this.image,
    this.color,
    this.link,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'sub_category_id')
  final String subCategoryId;
  @JsonKey(name: 'main_category_id')
  final String mainCategoryId;
  final String title;
  @JsonKey(nullable: true)
  final String caption;
  final String image;
  @JsonKey(nullable: true)
  final String color;
  @JsonKey(nullable: true)
  final String link;
  final int active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  SubCategory copyWith({
    int id,
    String subCategoryId,
    String mainCategoryId,
    String title,
    String caption,
    String image,
    String color,
    String link,
    int active,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      SubCategory(
        id: id ?? this.id,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        mainCategoryId: mainCategoryId ?? this.mainCategoryId,
        title: title ?? this.title,
        caption: caption ?? this.caption,
        image: image ?? this.image,
        color: color ?? this.color,
        link: link ?? this.link,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}
