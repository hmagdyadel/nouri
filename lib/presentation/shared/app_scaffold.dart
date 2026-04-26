import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/agpeya/view/agpeya_screen.dart';
import 'package:agpeya/presentation/competition/view/competition_screen.dart';
import 'package:agpeya/presentation/gospel/view/gospel_screen.dart';
import 'package:agpeya/presentation/home/view/home_screen.dart';
import 'package:agpeya/presentation/profile/view/profile_screen.dart';
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
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index) => setState(() => currentIndex = index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.homeTab),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: l10n.agpeyaTab),
          BottomNavigationBarItem(icon: const Icon(Icons.auto_stories), label: l10n.gospelTab),
          BottomNavigationBarItem(icon: const Icon(Icons.emoji_events), label: l10n.competitionTab),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: l10n.profileTab),
        ],
      ),
    );
  }
}
