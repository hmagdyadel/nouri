import 'package:json_annotation/json_annotation.dart';

part 'bible_model.g.dart';

@JsonSerializable()
class BibleBookModel {
  BibleBookModel({
    required this.abbrev,
    required this.name,
    required this.chapters,
  });

  final String abbrev;
  final String name;
  final List<List<String>> chapters;

  factory BibleBookModel.fromJson(Map<String, dynamic> json) =>
      _$BibleBookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BibleBookModelToJson(this);
}
