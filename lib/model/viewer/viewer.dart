import 'package:json_annotation/json_annotation.dart';

part 'viewer.g.dart';

@JsonSerializable(nullable: true)
class Viewer {
  Viewer({
    this.id,
    this.viewerId,
    this.relationId,
    this.userId,
    this.view,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'viewer_id')
  final String viewerId;
  @JsonKey(name: 'relation_id')
  final String relationId;
  @JsonKey(name: 'user_id')
  final String userId;
  final int view;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Viewer copyWith({
    int id,
    String viewerId,
    String relationId,
    String userId,
    int view,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Viewer(
        id: id ?? this.id,
        viewerId: viewerId ?? this.viewerId,
        relationId: relationId ?? this.relationId,
        userId: userId ?? this.userId,
        view: view ?? this.view,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);

  Map<String, dynamic> toJson() => _$ViewerToJson(this);
}
