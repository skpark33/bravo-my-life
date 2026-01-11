// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeData _$LifeDataFromJson(Map<String, dynamic> json) => LifeData(
      birthYear: (json['birthYear'] as num).toInt(),
      years: (json['years'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), LifeYear.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$LifeDataToJson(LifeData instance) => <String, dynamic>{
      'birthYear': instance.birthYear,
      'years': instance.years.map((k, e) => MapEntry(k.toString(), e)),
    };
