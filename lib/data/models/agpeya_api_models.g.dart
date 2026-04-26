// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agpeya_api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerHourResponse _$PrayerHourResponseFromJson(Map<String, dynamic> json) =>
    PrayerHourResponse(
      hour: json['hour'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$PrayerHourResponseToJson(PrayerHourResponse instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'title': instance.title,
      'content': instance.content,
    };

HourInfoResponse _$HourInfoResponseFromJson(Map<String, dynamic> json) =>
    HourInfoResponse(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$HourInfoResponseToJson(HourInfoResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'time': instance.time,
    };

DailyReadingsResponse _$DailyReadingsResponseFromJson(
        Map<String, dynamic> json) =>
    DailyReadingsResponse(
      gospel: json['gospel'] as String?,
      psalm: json['psalm'] as String?,
      epistle: json['epistle'] as String?,
    );

Map<String, dynamic> _$DailyReadingsResponseToJson(
        DailyReadingsResponse instance) =>
    <String, dynamic>{
      'gospel': instance.gospel,
      'psalm': instance.psalm,
      'epistle': instance.epistle,
    };

SynaxariumResponse _$SynaxariumResponseFromJson(Map<String, dynamic> json) =>
    SynaxariumResponse(
      title: json['title'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$SynaxariumResponseToJson(SynaxariumResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

FastingResponse _$FastingResponseFromJson(Map<String, dynamic> json) =>
    FastingResponse(
      isFasting: json['isFasting'] as bool?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$FastingResponseToJson(FastingResponse instance) =>
    <String, dynamic>{
      'isFasting': instance.isFasting,
      'name': instance.name,
    };

SearchResultResponse _$SearchResultResponseFromJson(
        Map<String, dynamic> json) =>
    SearchResultResponse(
      title: json['title'] as String?,
      snippet: json['snippet'] as String?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$SearchResultResponseToJson(
        SearchResultResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'snippet': instance.snippet,
      'source': instance.source,
    };
