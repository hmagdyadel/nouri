// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerLogModelAdapter extends TypeAdapter<PrayerLogModel> {
  @override
  final int typeId = 102;

  @override
  PrayerLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerLogModel(
      dateKey: fields[0] as String,
      hoursCompleted: (fields[1] as List).cast<int>(),
      gospelRead: fields[2] as bool,
      pointsEarned: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerLogModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.hoursCompleted)
      ..writeByte(2)
      ..write(obj.gospelRead)
      ..writeByte(3)
      ..write(obj.pointsEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerLogModel _$PrayerLogModelFromJson(Map<String, dynamic> json) =>
    PrayerLogModel(
      dateKey: json['dateKey'] as String,
      hoursCompleted: (json['hoursCompleted'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      gospelRead: json['gospelRead'] as bool,
      pointsEarned: (json['pointsEarned'] as num).toInt(),
    );

Map<String, dynamic> _$PrayerLogModelToJson(PrayerLogModel instance) =>
    <String, dynamic>{
      'dateKey': instance.dateKey,
      'hoursCompleted': instance.hoursCompleted,
      'gospelRead': instance.gospelRead,
      'pointsEarned': instance.pointsEarned,
    };
