// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_year.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeYear _$LifeYearFromJson(Map<String, dynamic> json) => LifeYear(
      year: (json['year'] as num).toInt(),
      score: (json['score'] as num?)?.toInt(),
      photoPath: json['photoPath'] as String?,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => LifeEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LifeYearToJson(LifeYear instance) => <String, dynamic>{
      'year': instance.year,
      'score': instance.score,
      'photoPath': instance.photoPath,
      'events': instance.events,
    };
