import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/network/bible_api_service.dart';
import 'package:agpeya/core/storage/hive_boxes.dart';
import 'package:agpeya/data/models/bible_api_models.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:agpeya/data/models/gospel_model.dart';

class GospelRepository {
  GospelRepository(this._bibleApiService);
  final BibleApiService _bibleApiService;

  Future<Either<Failure, GospelModel>> getDailyGospel() async {
    AppLogger.info('Fetching daily gospel');
    final Box<dynamic> box = Hive.box<dynamic>(HiveBoxes.bibleChapters);
    const String cacheKey = 'daily_gospel_arbnav_jhn_1';
    final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
    final bool online = !connectivity.contains(ConnectivityResult.none);

    try {
      if (online) {
        final ChapterResponseWrapper response = await _bibleApiService.getChapter('ARBNAV', 'JHN', 1);
        
        final List<String> verses = <String>[];
        if (response.chapter != null) {
          for (final VerseContent item in response.chapter!.content) {
            if (item.type == 'verse' && item.content != null) {
              verses.add(item.content!.join(' '));
            }
          }
        }
        
        final String extracted = verses.join('\n\n');
        
        if (extracted.length > 60) {
          await box.put(cacheKey, extracted);
          AppLogger.success('Gospel fetched and cached successfully', data: <String, dynamic>{'length': extracted.length});
          return Right<Failure, GospelModel>(
            GospelModel(
              arabic: extracted,
              english: fallbackGospelEnglish,
              coptic: fallbackGospelCoptic,
              reference: 'John 1:1-17',
            ),
          );
        }
      }
    } catch (e, stack) {
      AppLogger.error('Failed to fetch gospel from network', error: e, stack: stack);
    }

    AppLogger.warning('Offline or network failed — loading gospel from Hive', data: <String, dynamic>{'key': cacheKey});
    final dynamic cached = box.get(cacheKey);
    if (cached is String && cached.length > 60) {
      AppLogger.hive('Gospel cache hit', box: HiveBoxes.bibleChapters, key: cacheKey);
      return Right<Failure, GospelModel>(
        GospelModel(
          arabic: cached,
          english: fallbackGospelEnglish,
          coptic: fallbackGospelCoptic,
          reference: 'John 1:1-17',
        ),
      );
    }

    AppLogger.error('Gospel cache miss — using fallback');
    return const Right<Failure, GospelModel>(
      GospelModel(
        arabic: fallbackGospelArabic,
        english: fallbackGospelEnglish,
        coptic: fallbackGospelCoptic,
        reference: 'John 1:1-17',
      ),
    );
  }
}
