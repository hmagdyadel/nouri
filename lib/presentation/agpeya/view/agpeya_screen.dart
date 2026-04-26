import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/core/theme/app_colors.dart';
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
          return SafeArea(
            bottom: false,
            child: Container(
              color: AppColors.backgroundIvory,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 26),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[AppColors.backgroundNavy, AppColors.navyMid],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        const Icon(Icons.add, size: 18, color: AppColors.primaryGoldLight),
                        const SizedBox(height: 6),
                        const Text(
                          'الأجبية',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'صلوات الساعات السبع',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.goldSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      itemCount: loaded.hours.length,
                      itemBuilder: (BuildContext context, int index) {
                        final hour = loaded.hours[index];
                        final bool completed = loaded.completedToday.contains(hour.hour);
                        return GestureDetector(
                          onTap: () async {
                            final List<String> content = await context.read<AgpeyaCubit>().openHour(hour);
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
                          child: Container(
                            height: 96,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 6,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _accent(index),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        hour.arabicName,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.navyMid,
                                        ),
                                      ),
                                      Text(
                                        hour.englishName,
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
                                      ),
                                      Text(
                                        hour.copticName,
                                        style: const TextStyle(fontFamily: 'NotoSansCoptic', fontSize: 11, color: AppColors.copticRed),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGoldDark,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        hour.timeText,
                                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundIvory,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        hour.duration,
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textMuted),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (completed) const Icon(Icons.check_circle, size: 20, color: AppColors.primaryGoldDark),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _accent(int index) {
    const List<Color> colors = <Color>[
      AppColors.primaryGoldLight,
      Color(0xFFE07B39),
      AppColors.primaryGoldDark,
      Color(0xFF8B6914),
      AppColors.copticRed,
      AppColors.navyMid,
      AppColors.backgroundNavy,
    ];
    return colors[index % colors.length];
  }
}
