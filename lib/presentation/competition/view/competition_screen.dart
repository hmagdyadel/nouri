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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.competition_title),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: l10n.tab_weekly),
                Tab(text: l10n.tab_monthly),
                Tab(text: l10n.tab_alltime),
              ],
            ),
          ),
          body: BlocBuilder<CompetitionCubit, CompetitionState>(
            builder: (_, state) {
              if (state is! CompetitionLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
