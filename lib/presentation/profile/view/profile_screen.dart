import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/profile/viewmodel/profile_cubit.dart';
import 'package:agpeya/presentation/profile/viewmodel/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<ProfileCubit>(
      create: (_) => ProfileCubit()..load(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext ctx, ProfileState state) {
          if (state is! ProfileLoaded) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: <Widget>[
              const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
              const SizedBox(height: 12),
              Center(child: Text(state.name, style: const TextStyle(fontSize: 22))),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text(l10n.total_points, textAlign: TextAlign.start),
                  trailing: Text('${state.points}', textAlign: TextAlign.end),
                ),
              ),
              SwitchListTile(
                title: Text(l10n.enable_prayer_reminders),
                value: state.notificationsEnabled,
                onChanged: (bool value) => ctx.read<ProfileCubit>().toggleNotifications(value),
              ),
              Card(child: ListTile(title: Text('🔥 ${l10n.badge_streak_30}'))),
              Card(child: ListTile(title: Text('⭐ ${l10n.badge_full_agpeya}'))),
            ],
          );
        },
      ),
    );
  }
}
