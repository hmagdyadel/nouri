// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 101;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      avatarUrl: fields[3] as String?,
      currentStreak: fields[4] as int,
      totalPoints: fields[5] as int,
      username: fields[6] as String,
      church: fields[7] as String,
      city: fields[8] as String,
      isGuest: fields[9] as bool,
      profileComplete: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.currentStreak)
      ..writeByte(5)
      ..write(obj.totalPoints)
      ..writeByte(6)
      ..write(obj.username)
      ..writeByte(7)
      ..write(obj.church)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.isGuest)
      ..writeByte(10)
      ..write(obj.profileComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      church: json['church'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isGuest: json['isGuest'] as bool? ?? true,
      profileComplete: json['profileComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'currentStreak': instance.currentStreak,
      'totalPoints': instance.totalPoints,
      'username': instance.username,
      'church': instance.church,
      'city': instance.city,
      'isGuest': instance.isGuest,
      'profileComplete': instance.profileComplete,
    };
