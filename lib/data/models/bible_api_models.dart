import 'package:json_annotation/json_annotation.dart';

part 'bible_api_models.g.dart';

@JsonSerializable()
class ChapterResponseWrapper {
  ChapterResponseWrapper({this.chapter});

  final ChapterData? chapter;

  factory ChapterResponseWrapper.fromJson(Map<String, dynamic> json) =>
      _$ChapterResponseWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterResponseWrapperToJson(this);
}

@JsonSerializable()
class ChapterData {
  ChapterData({this.content = const <VerseContent>[]});

  final List<VerseContent> content;

  factory ChapterData.fromJson(Map<String, dynamic> json) =>
      _$ChapterDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterDataToJson(this);
}

@JsonSerializable()
class VerseContent {
  VerseContent({this.type, this.number, this.content});

  final String? type;
  final int? number;
  final List<String>? content;

  factory VerseContent.fromJson(Map<String, dynamic> json) =>
      _$VerseContentFromJson(json);
  Map<String, dynamic> toJson() => _$VerseContentToJson(this);
}
