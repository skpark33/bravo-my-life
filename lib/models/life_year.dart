import 'package:json_annotation/json_annotation.dart';
import 'life_event.dart';

part 'life_year.g.dart';

@JsonSerializable()
class LifeYear {
  final int year;
  int? score; // 1: Best ... 7: Worst, null: Not rated
  String? photoPath;
  List<LifeEvent> events;

  LifeYear({
    required this.year,
    this.score,
    this.photoPath,
    List<LifeEvent>? events,
  }) : events = events ?? [];

  factory LifeYear.fromJson(Map<String, dynamic> json) =>
      _$LifeYearFromJson(json);

  Map<String, dynamic> toJson() => _$LifeYearToJson(this);
}
