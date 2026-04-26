// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterResponseWrapper _$ChapterResponseWrapperFromJson(
        Map<String, dynamic> json) =>
    ChapterResponseWrapper(
      chapter: json['chapter'] == null
          ? null
          : ChapterData.fromJson(json['chapter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChapterResponseWrapperToJson(
        ChapterResponseWrapper instance) =>
    <String, dynamic>{
      'chapter': instance.chapter,
    };

ChapterData _$ChapterDataFromJson(Map<String, dynamic> json) => ChapterData(
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => VerseContent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VerseContent>[],
    );

Map<String, dynamic> _$ChapterDataToJson(ChapterData instance) =>
    <String, dynamic>{
      'content': instance.content,
    };

VerseContent _$VerseContentFromJson(Map<String, dynamic> json) => VerseContent(
      type: json['type'] as String?,
      number: (json['number'] as num?)?.toInt(),
      content:
          (json['content'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$VerseContentToJson(VerseContent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'number': instance.number,
      'content': instance.content,
    };
