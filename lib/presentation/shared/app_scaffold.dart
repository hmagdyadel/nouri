import 'dart:ui';

import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/agpeya/view/agpeya_screen.dart';
import 'package:agpeya/presentation/competition/view/competition_screen.dart';
import 'package:agpeya/presentation/gospel/view/gospel_screen.dart';
import 'package:agpeya/presentation/home/view/home_screen.dart';
import 'package:agpeya/presentation/profile/view/profile_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int currentIndex = 0;

  final List<Widget> pages = const <Widget>[
    HomeScreen(),
    AgpeyaScreen(),
    GospelScreen(),
    CompetitionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: IndexedStack(
                index: currentIndex,
                children: pages,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _GlassNavBar(
              selectedIndex: currentIndex,
              onTap: (int i) => setState(() => currentIndex = i),
              labels: <String>[
                l10n.homeTab,
                l10n.agpeyaTab,
                l10n.gospelTab,
                l10n.competitionTab,
                l10n.profileTab,
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<List<ConnectivityResult>>(
              stream: Connectivity().onConnectivityChanged,
              builder: (BuildContext context, AsyncSnapshot<List<ConnectivityResult>> snapshot) {
                final bool offline = snapshot.data?.contains(ConnectivityResult.none) ?? false;
                if (!offline) return const SizedBox.shrink();
                return SafeArea(
                  bottom: false,
                  child: Container(
                    color: Colors.orange.withValues(alpha: 0.9),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'وضع عدم الاتصال — يتم عرض المحتوى المحفوظ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.labels,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = <IconData>[
      Icons.home_rounded,
      Icons.menu_book_rounded,
      Icons.auto_stories_rounded,
      Icons.emoji_events_rounded,
      Icons.person_rounded,
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB8860B).withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(icons.length, (int index) {
                  final bool selected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFFB8860B).withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            icons[index],
                            color: selected ? const Color(0xFFB8860B) : const Color(0xFF9999B3),
                            size: selected ? 26 : 22,
                          ),
                          const SizedBox(height: 2),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: selected ? 11 : 0,
                              color: const Color(0xFFB8860B),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(labels[index]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
