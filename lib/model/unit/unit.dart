import 'package:json_annotation/json_annotation.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit {
  Unit({
    this.id,
    this.unitId,
    this.amount,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @JsonKey(name: 'unit_id')
  final String unitId;
  @JsonKey(fromJson: _fromDouble)
  final double amount;
  final String unit;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  static double _fromDouble(String value) =>
      value == null ? null : double.parse(value);

  Unit copyWith({
    int id,
    String unitId,
    String amount,
    String unit,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Unit(
        id: id ?? this.id,
        unitId: unitId ?? this.unitId,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
