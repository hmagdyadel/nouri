import 'package:agpeya/presentation/competition/viewmodel/competition_cubit.dart';
import 'package:agpeya/presentation/competition/viewmodel/competition_state.dart';
import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompetitionScreen extends StatelessWidget {
  const CompetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<CompetitionCubit>(
      create: (_) => CompetitionCubit()..load(),
      child: SafeArea(
        bottom: false,
        child: Container(
          color: AppColors.backgroundIvory,
          child: BlocBuilder<CompetitionCubit, CompetitionState>(
          builder: (BuildContext context, CompetitionState state) {
            if (state is! CompetitionLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final Duration diff = state.nextReset.difference(DateTime.now());
            final String countdown = '${diff.inDays}ي ${(diff.inHours % 24)}س ${(diff.inMinutes % 60)}د';
            return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.competition_title,
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 28,
                          color: AppColors.navyMid,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: <Color>[AppColors.primaryGoldLight, AppColors.primaryGoldDark]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.schedule, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('يتجدد خلال', style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                          const SizedBox(width: 8),
                          Text(
                            countdown,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _pill(
                            label: l10n.tab_weekly,
                            selected: state.period == CompetitionPeriod.weekly,
                            onTap: () => context.read<CompetitionCubit>().setPeriod(CompetitionPeriod.weekly),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _pill(
                            label: l10n.tab_monthly,
                            selected: state.period == CompetitionPeriod.monthly,
                            onTap: () => context.read<CompetitionCubit>().setPeriod(CompetitionPeriod.monthly),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _pill(
                            label: l10n.tab_alltime,
                            selected: state.period == CompetitionPeriod.allTime,
                            onTap: () => context.read<CompetitionCubit>().setPeriod(CompetitionPeriod.allTime),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _pill(
                            label: '🌍 ${l10n.leaderboard_global}',
                            selected: state.scope == CompetitionScope.global,
                            onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.global),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _pill(
                            label: '🏛️ ${l10n.leaderboard_church}',
                            selected: state.scope == CompetitionScope.church,
                            onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.church),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _pill(
                            label: '👨‍👩‍👧 ${l10n.leaderboard_family}',
                            selected: state.scope == CompetitionScope.family,
                            onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.family),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _podium(state),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: state.entries.length,
                      itemBuilder: (_, int index) {
                        final e = state.entries[index];
                        final bool currentUser = index == 0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: currentUser ? AppColors.goldSoft.withValues(alpha: 0.5) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: currentUser ? const Border(left: BorderSide(color: AppColors.primaryGoldDark, width: 4)) : null,
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 32,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(fontSize: 18, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(e['name'].toString(), style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                                    Text(
                                      e['church'].toString(),
                                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${e['points']}',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGoldDark,
                                    ),
                                  ),
                                  if ((e['streak'] as int? ?? 0) > 7)
                                    Text(
                                      '🔥 ${e['streak']}',
                                      style: const TextStyle(fontSize: 12, color: Colors.orange),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
          },
                ),
        ),
      ),
    );
  }

  Widget _pill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGoldDark : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.primaryGoldDark),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: selected ? Colors.white : AppColors.primaryGoldDark,
          ),
        ),
      ),
    );
  }

  Widget _podium(CompetitionLoaded state) {
    final List<Map<String, Object>> top = state.entries.take(3).toList();
    if (top.length < 3) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(child: _topItem('🥈', top[1], 52, false)),
          Expanded(child: _topItem('👑', top[0], 64, true)),
          Expanded(child: _topItem('🥉', top[2], 52, false)),
        ],
      ),
    );
  }

  Widget _topItem(String badge, Map<String, Object> user, double size, bool center) {
    return Column(
      children: <Widget>[
        Text(badge),
        CircleAvatar(radius: size / 2, child: const Icon(Icons.person)),
        const SizedBox(height: 6),
        Text(
          user['name'].toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryGoldDark,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '${user['points']}',
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          ),
        ),
        SizedBox(height: center ? 0 : 8),
      ],
    );
  }
}
