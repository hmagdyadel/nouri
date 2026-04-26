import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../models/agpeya_section.dart';
import '../../../core/logger/app_logger.dart';

@lazySingleton
class AgpeyaLocalSource {
  Future<Map<String, dynamic>?> loadLanguage(String lang) async {
    try {
      final String path = 'assets/data/agpeya_$lang.json';
      final String jsonString = await rootBundle.loadString(path);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to load local agpeya for $lang', error: e);
      return null;
    }
  }

  Future<List<AgpeyaSection>> getPrayerContent(int hour, int langIndex) async {
    final String lang = langIndex == 0 ? 'arabic' : (langIndex == 1 ? 'english' : 'coptic');
    final Map<String, dynamic>? data = await loadLanguage(lang);
    if (data == null) return <AgpeyaSection>[];

    final List<dynamic> hours = data['hours'] as List<dynamic>;
    final String hourKey = _mapHourToId(hour);
    final dynamic hourData = hours.firstWhere(
      (h) => h['id'] == hourKey,
      orElse: () => null,
    );

    if (hourData == null) return <AgpeyaSection>[];

    final List<AgpeyaSection> sections = <AgpeyaSection>[];
    
    // Header
    sections.add(AgpeyaSection(
      title: hourData['name'] as String,
      subtitle: hourData['englishName'] as String?,
      content: hourData['introduction'] as String,
    ));

    // Opening
    if (hourData['opening'] != null) {
      final List<dynamic> content = hourData['opening']['content'] as List<dynamic>;
      sections.add(AgpeyaSection(
        title: langIndex == 0 ? 'الافتتاحية' : 'Opening',
        content: content.join('\n\n'),
      ));
    }

    // Thanksgiving
    if (hourData['thanksgiving'] != null) {
      final Map<String, dynamic> tg = hourData['thanksgiving'] as Map<String, dynamic>;
      final List<dynamic> content = tg['content'] as List<dynamic>;
      sections.add(AgpeyaSection(
        title: tg['title'] as String,
        content: content.join('\n\n'),
      ));
    }

    // Introductory Psalm (Psalm 50)
    if (hourData['introductoryPsalm'] != null) {
      final Map<String, dynamic> ps = hourData['introductoryPsalm'] as Map<String, dynamic>;
      final List<dynamic> verses = ps['verses'] as List<dynamic>;
      final String content = verses.map((v) => '[${v['num']}] ${v['text']}').join('\n');
      sections.add(AgpeyaSection(
        title: ps['title'] as String,
        subtitle: ps['reference'] as String?,
        content: content,
      ));
    }

    // Psalms Intro
    if (hourData['psalmsIntro'] != null) {
      sections.add(AgpeyaSection(
        title: '',
        content: hourData['psalmsIntro'] as String,
      ));
    }

    // Psalms
    if (hourData['psalms'] != null) {
      final List<dynamic> psalms = hourData['psalms'] as List<dynamic>;
      for (final dynamic p in psalms) {
        final List<dynamic> verses = p['verses'] as List<dynamic>;
        final String content = verses.map((v) => '[${v['num']}] ${v['text']}').join('\n');
        sections.add(AgpeyaSection(
          title: p['title'] as String,
          subtitle: p['reference'] as String?,
          content: content,
        ));
      }
    }

    // Gospel
    if (hourData['gospel'] != null) {
      final Map<String, dynamic> gospel = hourData['gospel'] as Map<String, dynamic>;
      final List<dynamic> verses = gospel['verses'] as List<dynamic>;
      final String content = verses.map((v) => '[${v['num']}] ${v['text']}').join('\n');
      sections.add(AgpeyaSection(
        title: langIndex == 0 ? 'الإنجيل المقدس' : 'Holy Gospel',
        subtitle: '${gospel['rubric'] ?? ''}\n\n${gospel['reference']}',
        content: content,
      ));
    }

    // Litanies
    if (hourData['litanies'] != null) {
      final Map<String, dynamic> lit = hourData['litanies'] as Map<String, dynamic>;
      final List<dynamic> content = lit['content'] as List<dynamic>;
      sections.add(AgpeyaSection(
        title: lit['title'] as String,
        content: content.join('\n\n'),
      ));
    }

    // Lord's Prayer
    if (hourData['lordsPrayer'] != null) {
      final Map<String, dynamic> lp = hourData['lordsPrayer'] as Map<String, dynamic>;
      final List<dynamic> content = lp['content'] as List<dynamic>;
      sections.add(AgpeyaSection(
        title: lp['title'] as String,
        content: content.join('\n\n'),
      ));
    }

    // Closing
    if (hourData['closing'] != null) {
      final Map<String, dynamic> cl = hourData['closing'] as Map<String, dynamic>;
      final List<dynamic> content = cl['content'] as List<dynamic>;
      sections.add(AgpeyaSection(
        title: cl['title'] as String,
        content: content.join('\n\n'),
      ));
    }

    return sections;
  }

  String _mapHourToId(int hour) {
    switch (hour) {
      case 1: return 'prime';
      case 3: return 'terce';
      case 6: return 'sext';
      case 9: return 'none';
      case 11: return 'vespers';
      case 12: return 'compline';
      case 0: return 'midnight';
      default: return 'prime';
    }
  }
}
