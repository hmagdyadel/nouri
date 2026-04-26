import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => <Object?>[];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.uid);
  final String uid;
  @override
  List<Object> get props => <Object>[uid];
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}
