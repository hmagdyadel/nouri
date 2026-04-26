import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.totalPoints,
  });

  final String uid;
  final String name;
  final int totalPoints;

  @override
  List<Object> get props => <Object>[uid, name, totalPoints];
}
