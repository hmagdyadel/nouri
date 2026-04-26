import 'package:equatable/equatable.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => <Object?>[];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.name, this.points, this.notificationsEnabled);
  final String name;
  final int points;
  final bool notificationsEnabled;
  @override
  List<Object> get props => <Object>[name, points, notificationsEnabled];
}
