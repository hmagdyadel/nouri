import 'package:agpeya/design_preview/agpeya_design.dart';
import 'package:agpeya/design_preview/competition_design.dart';
import 'package:agpeya/design_preview/gospel_design.dart';
import 'package:agpeya/design_preview/home_design.dart';
import 'package:agpeya/design_preview/prayer_reader_design.dart';
import 'package:agpeya/design_preview/profile_sheet_design.dart';
import 'package:agpeya/presentation/agpeya/view/agpeya_screen.dart';
import 'package:agpeya/presentation/agpeya/view/prayer_reader_screen.dart';
import 'package:agpeya/presentation/competition/view/competition_screen.dart';
import 'package:agpeya/presentation/gospel/view/gospel_screen.dart';
import 'package:agpeya/presentation/home/view/home_screen.dart';
import 'package:flutter/material.dart';

class DesignRouter extends StatelessWidget {
  const DesignRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouri UI Design Preview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _section('Runtime Screens'),
          _btn(context, '🏠 Home Runtime', const HomeScreen()),
          _btn(context, '📖 Agpeya Runtime', const AgpeyaScreen()),
          _btn(
            context,
            '✝️ Prayer Reader Runtime',
            const PrayerReaderScreen(hourName: 'صلاة بكرة', hour: 1, content: <String>['نص تجريبي للصلاة', '', '']),
          ),
          _btn(context, '📗 Gospel Runtime', const GospelScreen()),
          _btn(context, '🏆 Competition Runtime', const CompetitionScreen()),
          const SizedBox(height: 8),
          _section('Static Design Preview'),
          _btn(context, '🏠 Home Design', const HomeDesign()),
          _btn(context, '📖 Agpeya Design', const AgpeyaDesign()),
          _btn(context, '✝️ Prayer Reader Design', const PrayerReaderDesign()),
          _btn(context, '📗 Gospel Design', const GospelDesign()),
          _btn(context, '🏆 Competition Design', const CompetitionDesign()),
          _btn(context, '👤 Profile Sheet Design', const ProfileSheetDesign()),
        ],
      ),
    );
  }

  Widget _btn(BuildContext context, String text, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen)),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(text)),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
      ),
    );
  }
}
