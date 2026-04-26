import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/core/theme/app_text_styles.dart';
import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/agpeya/view/prayer_reader_screen.dart';
import 'package:agpeya/presentation/home/view/profile_bottom_sheet.dart';
import 'package:agpeya/presentation/home/viewmodel/home_cubit.dart';
import 'package:agpeya/presentation/home/viewmodel/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit()..load(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          final HomeLoaded loaded = state as HomeLoaded;
          return SafeArea(
            bottom: false,
            child: Container(
              color: AppColors.backgroundIvory,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications_none_rounded, size: 28),
                                color: AppColors.navyMid,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.copticRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: GestureDetector(
                              onLongPress: () => context.push('/design-preview'),
                              child: Text(
                                l10n.nameBranding,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 24,
                                  color: AppColors.primaryGoldDark,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const ProfileBottomSheet(),
                              );
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryGoldDark, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    ((loaded.displayName ?? 'ن').trim().isNotEmpty
                                            ? (loaded.displayName ?? 'ن').trim().characters.first
                                            : 'ن')
                                        .toUpperCase(),
                                    style: AppTextStyles.arabicBody.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGoldDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          const Expanded(child: Divider(color: AppColors.textMuted)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              loaded.copticDate,
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
                            ),
                          ),
                          const Icon(Icons.add, size: 14, color: AppColors.textMuted),
                          const Expanded(child: Divider(color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: RepaintBoundary(
                        key: context.read<HomeCubit>().cardKey,
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 220),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[AppColors.backgroundNavy, AppColors.navyMid, Color(0xFF8B6914)],
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.primaryGoldDark.withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                loaded.cardCoptic,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.coptic.copyWith(fontSize: 14, color: AppColors.copticRed),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                loaded.cardArabic,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.arabicBody.copyWith(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                loaded.cardEnglish,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 13,
                                  color: AppColors.goldSoft,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: Colors.white70),
                                    ),
                                    child: const Text(
                                      '✝ نوري',
                                      style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                                    ),
                                  ),
                                  const Spacer(),
                                  OutlinedButton(
                                    onPressed: () async {
                                      final HomeCubit cubit = context.read<HomeCubit>();
                                      final bytes = await cubit.captureCard();
                                      if (bytes == null) return;
                                      final XFile file = XFile.fromData(
                                        bytes,
                                        mimeType: 'image/png',
                                        name: 'nouri_card.png',
                                      );
                                      await Share.shareXFiles(<XFile>[file]);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: const Icon(Icons.share, color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton(
                                    onPressed: () {},
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primaryGoldDark,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                    ),
                                    child: Text(l10n.start_prayer_btn),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          const Text(
                            'عرض الكل',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.primaryGoldDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.todays_progress,
                            style: AppTextStyles.arabicBody.copyWith(fontWeight: FontWeight.bold, fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: agpeyaHours.map((PrayerHourData hour) {
                          final bool done = loaded.progressHours.contains(hour.hour);
                          return Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final List<String> content = await context.read<HomeCubit>().openPrayerContent(hour.hour);
                                if (!context.mounted) return;
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => PrayerReaderScreen(
                                      hourName: hour.arabicName,
                                      hour: hour.hour,
                                      content: content,
                                    ),
                                  ),
                                );
                                if (!context.mounted) return;
                                await context.read<HomeCubit>().load();
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: done ? AppColors.primaryGoldDark : Colors.transparent,
                                      border: Border.all(
                                        color: done ? AppColors.primaryGoldDark : AppColors.textMuted,
                                      ),
                                      boxShadow: done
                                          ? <BoxShadow>[
                                              BoxShadow(
                                                color: AppColors.primaryGoldDark.withValues(alpha: 0.35),
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      done ? Icons.check : Icons.circle_outlined,
                                      color: done ? Colors.white : AppColors.textMuted,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(_shortLabel(hour.hour),
                                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: Row(
                        children: <Widget>[
                          _statChip('🔥', '${loaded.stats.streak}', l10n.your_streak),
                          _statChip('🏆', '#${loaded.stats.rank}', l10n.weekly_rank),
                          _statChip('✨', '${loaded.stats.pointsToday}', l10n.points_today),
                        ],
                      ),
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

  Widget _statChip(String icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12),
          ],
        ),
        child: Column(
          children: <Widget>[
            Text(icon, style: const TextStyle(fontSize: 20)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.navyMid)),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  String _shortLabel(int hour) {
    switch (hour) {
      case 1:
        return 'بكرة';
      case 3:
        return '٣';
      case 6:
        return '٦';
      case 9:
        return '٩';
      case 11:
        return 'غرب';
      case 12:
        return 'نوم';
      default:
        return 'منتصف';
    }
  }
}
