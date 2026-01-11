import 'package:json_annotation/json_annotation.dart';
import 'life_year.dart';

part 'life_data.g.dart';

@JsonSerializable()
class LifeData {
  int birthYear;
  Map<int, LifeYear> years; // Key: Year (e.g., 1980)

  LifeData({
    required this.birthYear,
    Map<int, LifeYear>? years,
  }) : years = years ?? {};

  factory LifeData.fromJson(Map<String, dynamic> json) =>
      _$LifeDataFromJson(json);

  Map<String, dynamic> toJson() => _$LifeDataToJson(this);
}
