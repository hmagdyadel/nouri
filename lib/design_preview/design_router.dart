import 'package:agpeya/design_preview/agpeya_design.dart';
import 'package:agpeya/design_preview/competition_design.dart';
import 'package:agpeya/design_preview/gospel_design.dart';
import 'package:agpeya/design_preview/home_design.dart';
import 'package:agpeya/design_preview/prayer_reader_design.dart';
import 'package:agpeya/design_preview/profile_sheet_design.dart';
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
}
