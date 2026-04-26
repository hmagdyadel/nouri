import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 100)
@JsonSerializable()
class SettingsModel {
  SettingsModel({
    this.language = 'ar',
    this.darkMode = false,
    this.notifications = true,
    this.fontSize = 20,
  });

  @HiveField(0)
  final String language;

  @HiveField(1)
  final bool darkMode;

  @HiveField(2)
  final bool notifications;

  @HiveField(3)
  final double fontSize;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
