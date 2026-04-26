import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/auth/viewmodel/auth_cubit.dart';
import 'package:agpeya/presentation/auth/viewmodel/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthAuthenticated) {
            context.go('/app');
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.login_title)),
            body: Center(
              child: state is AuthLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                      onPressed: () => context.read<AuthCubit>().loginAnonymously(),
                      child: Text(l10n.login_action),
                    ),
            ),
          );
        },
      ),
    );
  }
}
