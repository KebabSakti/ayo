import 'package:json_annotation/json_annotation.dart';

part 'courier_model.g.dart';

@JsonSerializable()
class Courier {
  Courier({
    this.id,
    this.courierId,
    this.mitraId,
    this.name,
    this.phone,
    this.picture,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'courier_id')
  final String courierId;
  @JsonKey(name: 'mitra_id')
  final String mitraId;
  final String name;
  final String phone;
  final String picture;
  final int active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Courier copyWith({
    int id,
    String courierId,
    String mitraId,
    String name,
    String phone,
    String picture,
    int active,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Courier(
        id: id ?? this.id,
        courierId: courierId ?? this.courierId,
        mitraId: mitraId ?? this.mitraId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        picture: picture ?? this.picture,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Courier.fromJson(Map<String, dynamic> json) => _$CourierFromJson(json);

  Map<String, dynamic> toJson() => _$CourierToJson(this);
}
