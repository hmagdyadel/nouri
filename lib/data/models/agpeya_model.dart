import 'package:json_annotation/json_annotation.dart';

part 'agpeya_model.g.dart';

@JsonSerializable()
class AgpeyaFileModel {
  AgpeyaFileModel({required this.hours});
  final List<AgpeyaHourModel> hours;

  factory AgpeyaFileModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaFileModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaFileModelToJson(this);
}

@JsonSerializable()
class AgpeyaHourModel {
  AgpeyaHourModel({
    required this.id,
    required this.name,
    required this.englishName,
    this.traditionalTime,
    this.introduction,
    this.opening,
    this.thanksgiving,
    this.introductoryPsalm,
    this.psalmsIntro,
    this.psalms,
    this.gospel,
    this.litanies,
    this.lordsPrayer,
    this.closing,
  });

  final String id;
  final String name;
  final String englishName;
  final String? traditionalTime;
  final String? introduction;
  final AgpeyaSectionModel? opening;
  final AgpeyaTitledSectionModel? thanksgiving;
  final AgpeyaPsalmModel? introductoryPsalm;
  final String? psalmsIntro;
  final List<AgpeyaPsalmModel>? psalms;
  final AgpeyaGospelModel? gospel;
  final AgpeyaTitledSectionModel? litanies;
  final AgpeyaSectionModel? lordsPrayer;
  final AgpeyaTitledSectionModel? closing;

  factory AgpeyaHourModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaHourModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaHourModelToJson(this);
}

@JsonSerializable()
class AgpeyaSectionModel {
  AgpeyaSectionModel({this.inline, required this.content, this.title});
  final bool? inline;
  final String? title;
  final List<String> content;

  factory AgpeyaSectionModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaSectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaSectionModelToJson(this);
}

@JsonSerializable()
class AgpeyaTitledSectionModel {
  AgpeyaTitledSectionModel({
    required this.title,
    this.inline,
    required this.content,
  });
  final String title;
  final bool? inline;
  final List<String> content;

  factory AgpeyaTitledSectionModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaTitledSectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaTitledSectionModelToJson(this);
}

@JsonSerializable()
class AgpeyaPsalmModel {
  AgpeyaPsalmModel({
    required this.title,
    required this.reference,
    required this.verses,
  });
  final String title;
  final String reference;
  final List<AgpeyaVerseModel> verses;

  factory AgpeyaPsalmModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaPsalmModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaPsalmModelToJson(this);
}

@JsonSerializable()
class AgpeyaGospelModel {
  AgpeyaGospelModel({
    required this.reference,
    this.rubric,
    required this.verses,
  });
  final String reference;
  final String? rubric;
  final List<AgpeyaVerseModel> verses;

  factory AgpeyaGospelModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaGospelModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaGospelModelToJson(this);
}

@JsonSerializable()
class AgpeyaVerseModel {
  AgpeyaVerseModel({required this.num, required this.text});
  final int num;
  final String text;

  factory AgpeyaVerseModel.fromJson(Map<String, dynamic> json) =>
      _$AgpeyaVerseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgpeyaVerseModelToJson(this);
}
