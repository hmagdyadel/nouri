// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 100;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      language: fields[0] as String,
      darkMode: fields[1] as bool,
      notifications: fields[2] as bool,
      fontSize: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.darkMode)
      ..writeByte(2)
      ..write(obj.notifications)
      ..writeByte(3)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      language: json['language'] as String? ?? 'ar',
      darkMode: json['darkMode'] as bool? ?? false,
      notifications: json['notifications'] as bool? ?? true,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 20,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'darkMode': instance.darkMode,
      'notifications': instance.notifications,
      'fontSize': instance.fontSize,
    };
