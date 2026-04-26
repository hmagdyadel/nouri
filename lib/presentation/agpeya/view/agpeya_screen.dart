import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/agpeya/view/prayer_reader_screen.dart';
import 'package:agpeya/presentation/agpeya/viewmodel/agpeya_cubit.dart';
import 'package:agpeya/presentation/agpeya/viewmodel/agpeya_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgpeyaScreen extends StatelessWidget {
  const AgpeyaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<AgpeyaCubit>(
      create: (_) => AgpeyaCubit()..loadHours(),
      child: BlocBuilder<AgpeyaCubit, AgpeyaState>(
        builder: (BuildContext context, AgpeyaState state) {
          if (state is AgpeyaLoading || state is AgpeyaInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          final AgpeyaLoaded loaded = state as AgpeyaLoaded;
          return ListView.builder(
            itemCount: loaded.hours.length,
            itemBuilder: (BuildContext context, int index) {
              final hour = loaded.hours[index];
              final bool completed = loaded.completedToday.contains(hour.hour);
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(hour.arabicName, textAlign: TextAlign.start),
                  subtitle: Text(
                    l10n.hour_subtitle_format(hour.englishName, hour.timeText),
                    textAlign: TextAlign.start,
                  ),
                  trailing: completed ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
                  onTap: () async {
                    final String content = await context.read<AgpeyaCubit>().openHour(hour);
                    if (!context.mounted) return;
                    final bool? didComplete = await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) => PrayerReaderScreen(
                          hourName: hour.arabicName,
                          hour: hour.hour,
                          content: content,
                        ),
                      ),
                    );
                    if (!context.mounted) return;
                    if (didComplete == true) {
                      final bool ok = await context.read<AgpeyaCubit>().completeHour(hour.hour);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ok ? l10n.prayer_logged_success : l10n.prayer_logged_error)),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
