import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 101)
@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.currentStreak = 0,
    this.totalPoints = 0,
    this.username = '',
    this.church = '',
    this.city = '',
    this.isGuest = true,
    this.profileComplete = false,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? avatarUrl;
  @HiveField(4)
  final int currentStreak;
  @HiveField(5)
  final int totalPoints;
  @HiveField(6)
  final String username;
  @HiveField(7)
  final String church;
  @HiveField(8)
  final String city;
  @HiveField(9)
  final bool isGuest;
  @HiveField(10)
  final bool profileComplete;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        uid, name, email, avatarUrl, currentStreak, totalPoints,
        username, church, city, isGuest, profileComplete,
      ];
}
