import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_cubit.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GospelScreen extends StatelessWidget {
  const GospelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<GospelCubit>(
      create: (_) => GospelCubit()..load(),
      child: BlocBuilder<GospelCubit, GospelState>(
        builder: (_, state) {
          if (state is! GospelLoaded) return const Center(child: CircularProgressIndicator());
          return DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                TabBar(
                  tabs: <Widget>[
                    Tab(text: l10n.tab_arabic),
                    Tab(text: l10n.tab_english),
                    Tab(text: l10n.tab_coptic),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsetsDirectional.all(16),
                        child: Text(state.ar, textAlign: TextAlign.start),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.all(16),
                        child: Text(state.en, textAlign: TextAlign.start),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.all(16),
                        child: Text(state.cop, textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
