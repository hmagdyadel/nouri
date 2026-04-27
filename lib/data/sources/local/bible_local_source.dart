import 'dart:convert';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/models/bible_model.dart';
import 'package:flutter/services.dart';

class BibleLocalSource {
  List<BibleBookModel>? _arCache;
  List<BibleBookModel>? _enCache;

  Future<List<BibleBookModel>> getBible(String lang) async {
    if (lang == 'ar' && _arCache != null) return _arCache!;
    if (lang == 'en' && _enCache != null) return _enCache!;

    final String assetPath = lang == 'ar' ? 'assets/bible/bible_ar.json' : 'assets/bible/bible_en.json';
    AppLogger.info('Loading Bible JSON', data: <String, dynamic>{'path': assetPath});
    
    try {
      final String jsonStr = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
      final List<BibleBookModel> bible = jsonList
          .map((dynamic e) => BibleBookModel.fromJson(e as Map<String, dynamic>))
          .toList();
          
      if (lang == 'ar') {
        _arCache = bible;
      } else {
        _enCache = bible;
      }
      return bible;
    } catch (e, stack) {
      AppLogger.error('Failed to load Bible JSON', error: e, stack: stack);
      rethrow;
    }
  }

  Future<BibleBookModel?> getBook(String abbrev, String lang) async {
    final List<BibleBookModel> bible = await getBible(lang);
    try {
      return bible.firstWhere((BibleBookModel b) => b.abbrev.toLowerCase() == abbrev.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Future<List<String>?> getChapter(String abbrev, int chapter, String lang) async {
    final BibleBookModel? book = await getBook(abbrev, lang);
    if (book == null) return null;
    
    // Chapters in JSON are 0-indexed while the request is 1-indexed
    if (chapter < 1 || chapter > book.chapters.length) return null;
    return book.chapters[chapter - 1];
  }
}
