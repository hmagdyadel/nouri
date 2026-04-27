// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agpeya_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgpeyaFileModel _$AgpeyaFileModelFromJson(Map<String, dynamic> json) =>
    AgpeyaFileModel(
      hours: (json['hours'] as List<dynamic>)
          .map((e) => AgpeyaHourModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgpeyaFileModelToJson(AgpeyaFileModel instance) =>
    <String, dynamic>{
      'hours': instance.hours,
    };

AgpeyaHourModel _$AgpeyaHourModelFromJson(Map<String, dynamic> json) =>
    AgpeyaHourModel(
      id: json['id'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      traditionalTime: json['traditionalTime'] as String?,
      introduction: json['introduction'] as String?,
      opening: json['opening'] == null
          ? null
          : AgpeyaSectionModel.fromJson(
              json['opening'] as Map<String, dynamic>),
      thanksgiving: json['thanksgiving'] == null
          ? null
          : AgpeyaTitledSectionModel.fromJson(
              json['thanksgiving'] as Map<String, dynamic>),
      introductoryPsalm: json['introductoryPsalm'] == null
          ? null
          : AgpeyaPsalmModel.fromJson(
              json['introductoryPsalm'] as Map<String, dynamic>),
      psalmsIntro: json['psalmsIntro'] as String?,
      psalms: (json['psalms'] as List<dynamic>?)
          ?.map((e) => AgpeyaPsalmModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      gospel: json['gospel'] == null
          ? null
          : AgpeyaGospelModel.fromJson(json['gospel'] as Map<String, dynamic>),
      litanies: json['litanies'] == null
          ? null
          : AgpeyaTitledSectionModel.fromJson(
              json['litanies'] as Map<String, dynamic>),
      lordsPrayer: json['lordsPrayer'] == null
          ? null
          : AgpeyaSectionModel.fromJson(
              json['lordsPrayer'] as Map<String, dynamic>),
      closing: json['closing'] == null
          ? null
          : AgpeyaTitledSectionModel.fromJson(
              json['closing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgpeyaHourModelToJson(AgpeyaHourModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'englishName': instance.englishName,
      'traditionalTime': instance.traditionalTime,
      'introduction': instance.introduction,
      'opening': instance.opening,
      'thanksgiving': instance.thanksgiving,
      'introductoryPsalm': instance.introductoryPsalm,
      'psalmsIntro': instance.psalmsIntro,
      'psalms': instance.psalms,
      'gospel': instance.gospel,
      'litanies': instance.litanies,
      'lordsPrayer': instance.lordsPrayer,
      'closing': instance.closing,
    };

AgpeyaSectionModel _$AgpeyaSectionModelFromJson(Map<String, dynamic> json) =>
    AgpeyaSectionModel(
      inline: json['inline'] as bool?,
      content:
          (json['content'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$AgpeyaSectionModelToJson(AgpeyaSectionModel instance) =>
    <String, dynamic>{
      'inline': instance.inline,
      'title': instance.title,
      'content': instance.content,
    };

AgpeyaTitledSectionModel _$AgpeyaTitledSectionModelFromJson(
        Map<String, dynamic> json) =>
    AgpeyaTitledSectionModel(
      title: json['title'] as String,
      inline: json['inline'] as bool?,
      content:
          (json['content'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AgpeyaTitledSectionModelToJson(
        AgpeyaTitledSectionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'inline': instance.inline,
      'content': instance.content,
    };

AgpeyaPsalmModel _$AgpeyaPsalmModelFromJson(Map<String, dynamic> json) =>
    AgpeyaPsalmModel(
      title: json['title'] as String,
      reference: json['reference'] as String,
      verses: (json['verses'] as List<dynamic>)
          .map((e) => AgpeyaVerseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgpeyaPsalmModelToJson(AgpeyaPsalmModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'reference': instance.reference,
      'verses': instance.verses,
    };

AgpeyaGospelModel _$AgpeyaGospelModelFromJson(Map<String, dynamic> json) =>
    AgpeyaGospelModel(
      reference: json['reference'] as String,
      rubric: json['rubric'] as String?,
      verses: (json['verses'] as List<dynamic>)
          .map((e) => AgpeyaVerseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgpeyaGospelModelToJson(AgpeyaGospelModel instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'rubric': instance.rubric,
      'verses': instance.verses,
    };

AgpeyaVerseModel _$AgpeyaVerseModelFromJson(Map<String, dynamic> json) =>
    AgpeyaVerseModel(
      num: (json['num'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$AgpeyaVerseModelToJson(AgpeyaVerseModel instance) =>
    <String, dynamic>{
      'num': instance.num,
      'text': instance.text,
    };
