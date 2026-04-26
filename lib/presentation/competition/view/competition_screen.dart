import 'package:agpeya/presentation/competition/viewmodel/competition_cubit.dart';
import 'package:agpeya/presentation/competition/viewmodel/competition_state.dart';
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
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.competition_title)),
        body: BlocBuilder<CompetitionCubit, CompetitionState>(
          builder: (BuildContext context, CompetitionState state) {
            if (state is! CompetitionLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final Duration diff = state.nextReset.difference(DateTime.now());
            final String countdown =
                '${diff.inDays}d ${(diff.inHours % 24)}h ${(diff.inMinutes % 60)}m';
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 6),
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
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('${l10n.next_reset}: $countdown'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 6),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _pill(
                          label: l10n.leaderboard_global,
                          selected: state.scope == CompetitionScope.global,
                          onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.global),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _pill(
                          label: l10n.leaderboard_church,
                          selected: state.scope == CompetitionScope.church,
                          onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.church),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _pill(
                          label: l10n.leaderboard_family,
                          selected: state.scope == CompetitionScope.family,
                          onTap: () => context.read<CompetitionCubit>().setScope(CompetitionScope.family),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.entries.length,
                    itemBuilder: (_, int index) {
                      final e = state.entries[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(e['name'].toString(), textAlign: TextAlign.start),
                        subtitle: Text(e['church'].toString(), textAlign: TextAlign.start),
                        trailing: Text(
                          '${e['points']} ${l10n.competition_points_suffix}',
                          textAlign: TextAlign.end,
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
          color: selected ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.amber),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
