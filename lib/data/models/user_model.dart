import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.currentStreak = 0,
    this.totalPoints = 0,
  });

  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final int currentStreak;
  final int totalPoints;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        currentStreak: json['currentStreak'] as int? ?? 0,
        totalPoints: json['totalPoints'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'currentStreak': currentStreak,
        'totalPoints': totalPoints,
      };

  @override
  List<Object?> get props => <Object?>[uid, name, email, avatarUrl, currentStreak, totalPoints];
}
