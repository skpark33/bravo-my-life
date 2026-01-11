import 'package:json_annotation/json_annotation.dart';

part 'life_event.g.dart';

@JsonSerializable()
class LifeEvent {
  final String id;
  String title;
  String description;
  final DateTime? date;

  LifeEvent({
    required this.id,
    required this.title,
    this.description = '',
    this.date,
  });

  factory LifeEvent.fromJson(Map<String, dynamic> json) =>
      _$LifeEventFromJson(json);

  Map<String, dynamic> toJson() => _$LifeEventToJson(this);
}
