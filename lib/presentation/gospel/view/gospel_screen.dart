import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_cubit.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(l10n.todays_reading, style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
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
                      _VersesView(
                        text: state.ar,
                        highlighted: state.highlightedVerse,
                        onToggle: (int i) => context.read<GospelCubit>().toggleHighlightedVerse(i),
                      ),
                      _VersesView(
                        text: state.en,
                        highlighted: state.highlightedVerse,
                        onToggle: (int i) => context.read<GospelCubit>().toggleHighlightedVerse(i),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.all(16),
                        child: Text(state.cop, textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton(
                          onPressed: state.readToday
                              ? null
                              : () {
                                  context.read<GospelCubit>().markReadToday();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(l10n.gospel_completed)));
                                },
                          child: Text(state.readToday ? l10n.gospel_completed : l10n.read_gospel_btn),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => Share.share(state.ar),
                        icon: const Icon(Icons.share),
                        tooltip: l10n.share_verse,
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

class _VersesView extends StatelessWidget {
  const _VersesView({
    required this.text,
    required this.highlighted,
    required this.onToggle,
  });

  final String text;
  final int? highlighted;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final List<String> verses = text
        .split(RegExp(r'[\n\.]+'))
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .toList();
    return ListView.builder(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: verses.length,
      itemBuilder: (_, int index) {
        final bool active = highlighted == index;
        return GestureDetector(
          onLongPress: () => onToggle(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              color: active ? Colors.amber.withValues(alpha: 0.22) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(radius: 12, child: Text('${index + 1}', style: const TextStyle(fontSize: 11))),
                const SizedBox(width: 8),
                Expanded(child: Text(verses[index], textAlign: TextAlign.start)),
              ],
            ),
          ),
        );
      },
    );
  }
}
