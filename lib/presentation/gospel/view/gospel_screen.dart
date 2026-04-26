import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_cubit.dart';
import 'package:agpeya/presentation/gospel/viewmodel/gospel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class GospelScreen extends StatelessWidget {
  const GospelScreen({super.key});

  @override
  Widget build(BuildContext rootContext) {
    final l10n = AppLocalizations.of(rootContext)!;
    return BlocProvider<GospelCubit>(
      create: (_) => GospelCubit()..load(),
      child: BlocBuilder<GospelCubit, GospelState>(
        builder: (BuildContext context, GospelState state) {
          if (state is! GospelLoaded) return const Center(child: CircularProgressIndicator());
          return DefaultTabController(
            length: 3,
            child: SafeArea(
              bottom: false,
              child: Container(
                color: AppColors.backgroundIvory,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[AppColors.copticRed, AppColors.backgroundNavy]),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('✝', style: TextStyle(color: Colors.white, fontSize: 32)),
                          SizedBox(height: 4),
                          Text(
                            'إنجيل اليوم',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'إنجيل يوحنا ١٠: ١-١٦',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.goldSoft),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TabBar(
                      labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      indicator: BoxDecoration(
                        color: AppColors.primaryGoldDark,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.primaryGoldDark,
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
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              state.cop,
                              style: const TextStyle(fontFamily: 'NotoSansCoptic', fontSize: 18, color: AppColors.copticRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: state.readToday ? AppColors.sageGreen : null,
                                gradient: state.readToday
                                    ? null
                                    : const LinearGradient(colors: <Color>[AppColors.primaryGoldLight, AppColors.primaryGoldDark]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextButton(
                                onPressed: state.readToday
                                    ? null
                                    : () {
                                        context.read<GospelCubit>().markReadToday();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(l10n.gospel_completed)));
                                      },
                                child: Text(
                                  state.readToday ? 'تم القراءة ✓' : 'قرأت الإنجيل اليوم ✝',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
              ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemCount: verses.length,
      itemBuilder: (_, int index) {
        final bool active = highlighted == index;
        return GestureDetector(
          onLongPress: () => onToggle(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: active ? AppColors.goldSoft.withValues(alpha: 0.8) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primaryGoldDark,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    verses[index],
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, color: AppColors.navyMid, height: 1.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
