import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/core/theme/app_text_styles.dart';
import 'package:agpeya/l10n/app_localizations.dart';
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
          final String greeting = switch (loaded.greeting) {
            'morning' => l10n.greeting_morning,
            'afternoon' => l10n.greeting_afternoon,
            _ => l10n.greeting_evening,
          };
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                title: GestureDetector(
                  onLongPress: () => context.push('/design-preview'),
                  child: Text('${l10n.nameBranding} • $greeting'),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const ProfileBottomSheet(),
                      );
                    },
                    icon: const CircleAvatar(
                      radius: 14,
                      child: Icon(Icons.person, size: 16),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      loaded.copticDate,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.arabicBody.copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: RepaintBoundary(
                    key: context.read<HomeCubit>().cardKey,
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[AppColors.primaryGoldLight, AppColors.backgroundNavy],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(loaded.cardCoptic, textAlign: TextAlign.start, style: AppTextStyles.coptic),
                          const SizedBox(height: 12),
                          Text(
                            loaded.cardArabic,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.arabicBody.copyWith(color: Colors.white, fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loaded.cardEnglish,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                          if ((loaded.displayName ?? '').isNotEmpty || (loaded.username ?? '').isNotEmpty) ...<Widget>[
                            const SizedBox(height: 8),
                            Text(
                              '${loaded.displayName ?? ''} ${loaded.username != null ? '@${loaded.username}' : ''}'.trim(),
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {},
                                  child: Text(l10n.start_prayer_btn),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: () async {
                                  final HomeCubit cubit = context.read<HomeCubit>();
                                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                                  await Future<void>.delayed(const Duration(milliseconds: 50));
                                  final bytes = await cubit.captureCard();
                                  if (bytes == null) return;
                                  final XFile file = XFile.fromData(
                                    bytes,
                                    mimeType: 'image/png',
                                    name: 'nouri_card.png',
                                  );
                                  await Share.shareXFiles(<XFile>[file]);
                                  if (loaded.isGuest &&
                                      (loaded.displayName == null || loaded.displayName!.isEmpty) &&
                                      (loaded.username == null || loaded.username!.isEmpty)) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.add_name_to_card_snackbar),
                                        action: SnackBarAction(
                                          label: l10n.openProfileAction,
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (_) => const ProfileBottomSheet(),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.share),
                                tooltip: l10n.share_card_btn,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _statChip('🔥', '${loaded.stats.streak}', l10n.your_streak),
                              _statChip('🏆', '#${loaded.stats.rank}', l10n.weekly_rank),
                              _statChip('✨', '${loaded.stats.pointsToday}', l10n.points_today),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statChip(String icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: <Widget>[
            Text(icon),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
