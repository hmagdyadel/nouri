// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BibleBookModel _$BibleBookModelFromJson(Map<String, dynamic> json) =>
    BibleBookModel(
      abbrev: json['abbrev'] as String,
      name: json['name'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$BibleBookModelToJson(BibleBookModel instance) =>
    <String, dynamic>{
      'abbrev': instance.abbrev,
      'name': instance.name,
      'chapters': instance.chapters,
    };
