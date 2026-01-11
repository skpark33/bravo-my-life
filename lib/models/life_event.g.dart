// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeEvent _$LifeEventFromJson(Map<String, dynamic> json) => LifeEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$LifeEventToJson(LifeEvent instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
    };
