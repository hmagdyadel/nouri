import 'package:json_annotation/json_annotation.dart';

part 'agpeya_api_models.g.dart';

@JsonSerializable()
class PrayerHourResponse {
  PrayerHourResponse({
    this.hour,
    this.title,
    this.content,
  });

  final String? hour;
  final String? title;
  final String? content;

  factory PrayerHourResponse.fromJson(Map<String, dynamic> json) =>
      _$PrayerHourResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerHourResponseToJson(this);
}

@JsonSerializable()
class HourInfoResponse {
  HourInfoResponse({
    this.name,
    this.slug,
    this.time,
  });

  final String? name;
  final String? slug;
  final String? time;

  factory HourInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$HourInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HourInfoResponseToJson(this);
}

@JsonSerializable()
class DailyReadingsResponse {
  DailyReadingsResponse({
    this.gospel,
    this.psalm,
    this.epistle,
  });

  final String? gospel;
  final String? psalm;
  final String? epistle;

  factory DailyReadingsResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyReadingsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DailyReadingsResponseToJson(this);
}

@JsonSerializable()
class SynaxariumResponse {
  SynaxariumResponse({
    this.title,
    this.content,
  });

  final String? title;
  final String? content;

  factory SynaxariumResponse.fromJson(Map<String, dynamic> json) =>
      _$SynaxariumResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SynaxariumResponseToJson(this);
}

@JsonSerializable()
class FastingResponse {
  FastingResponse({
    this.isFasting,
    this.name,
  });

  final bool? isFasting;
  final String? name;

  factory FastingResponse.fromJson(Map<String, dynamic> json) =>
      _$FastingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FastingResponseToJson(this);
}

@JsonSerializable()
class SearchResultResponse {
  SearchResultResponse({
    this.title,
    this.snippet,
    this.source,
  });

  final String? title;
  final String? snippet;
  final String? source;

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResultResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultResponseToJson(this);
}
