import 'package:json_annotation/json_annotation.dart';

part 'slide_banner.g.dart';

@JsonSerializable(nullable: true)
class SlideBanner {
  @JsonKey(name: 'promo_id')
  final String promoId;
  @JsonKey(name: 'main_category_id', nullable: true)
  final String mainCategoryId;
  final String url;
  final int home;
  final int active;
  @JsonKey(nullable: true)
  final String link;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  SlideBanner({
    this.promoId,
    this.mainCategoryId,
    this.url,
    this.home,
    this.active,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory SlideBanner.fromJson(Map<String, dynamic> json) =>
      _$SlideBannerFromJson(json);

  Map<String, dynamic> toJson() => _$SlideBannerToJson(this);
}
