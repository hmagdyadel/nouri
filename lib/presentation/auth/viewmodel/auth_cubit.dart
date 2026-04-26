import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? repository})
      : _repository = repository ?? getIt<AuthRepository>(),
        super(AuthInitial());

  final AuthRepository _repository;

  Future<void> loginAnonymously() async {
    emit(AuthLoading());
    final result = await _repository.signInAnonymously();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (credential) => emit(AuthAuthenticated(credential.user?.uid ?? '')),
    );
  }
}
