import 'dart:convert';

import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/models/agpeya_model.dart';
import 'package:flutter/services.dart';

class AgpeyaLocalSource {
  AgpeyaFileModel? _arCache;
  AgpeyaFileModel? _enCache;
  AgpeyaFileModel? _copCache;

  Future<AgpeyaHourModel?> getHour(String hourId, String lang) async {
    final AgpeyaFileModel file = await _loadFile(lang);
    AppLogger.info(
      'Loading Agpeya from local JSON',
      data: <String, dynamic>{'hour': hourId, 'lang': lang},
    );
    try {
      final AgpeyaHourModel hour = file.hours.firstWhere((AgpeyaHourModel h) => h.id == hourId);
      AppLogger.success('Agpeya hour loaded', data: <String, dynamic>{'hour': hourId, 'lang': lang});
      return hour;
    } catch (_) {
      AppLogger.error(
        'Hour not found in local file',
        error: 'id=$hourId not in $lang file',
      );
      return null;
    }
  }

  Future<List<AgpeyaHourModel>> getAllHours(String lang) async {
    final AgpeyaFileModel file = await _loadFile(lang);
    return file.hours;
  }

  Future<AgpeyaFileModel> _loadFile(String lang) async {
    switch (lang) {
      case 'ar':
        if (_arCache != null) return _arCache!;
        _arCache = await _parse('assets/agpeya/agpeya_ar.json', fallback: 'assets/data/agpeya_arabic.json');
        return _arCache!;
      case 'en':
        if (_enCache != null) return _enCache!;
        _enCache = await _parse('assets/agpeya/agpeya_en.json', fallback: 'assets/data/agpeya_english.json');
        return _enCache!;
      case 'cop':
        if (_copCache != null) return _copCache!;
        _copCache = await _parse('assets/agpeya/agpeya_cop.json', fallback: 'assets/data/agpeya_coptic.json');
        return _copCache!;
      default:
        throw Exception('Unknown language: $lang');
    }
  }

  Future<AgpeyaFileModel> _parse(String assetPath, {required String fallback}) async {
    AppLogger.info('Parsing Agpeya JSON', data: <String, dynamic>{'path': assetPath});
    try {
      final String jsonStr = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AgpeyaFileModel.fromJson(json);
    } catch (_) {
      final String jsonStr = await rootBundle.loadString(fallback);
      final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AgpeyaFileModel.fromJson(json);
    }
  }
}
