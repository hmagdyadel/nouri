import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/data/repositories/bible_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:agpeya/data/models/gospel_model.dart';

class GospelRepository {
  GospelRepository(this._bibleRepository);
  final BibleRepository _bibleRepository;

  Future<Either<Failure, GospelModel>> getDailyGospel() async {
    AppLogger.info('Fetching daily gospel locally');

    try {
      final Either<Failure, List<String>> arChapter = await _bibleRepository.getChapter('jn', 1, 'ar');
      final Either<Failure, List<String>> enChapter = await _bibleRepository.getChapter('jn', 1, 'en');

      String arabic = fallbackGospelArabic;
      String english = fallbackGospelEnglish;

      arChapter.fold(
        (Failure f) => AppLogger.error('Failed to load Arabic gospel: ${f.message}'),
        (List<String> verses) {
          // John 1:1-17
          if (verses.length >= 17) {
            arabic = verses.sublist(0, 17).join('\n\n');
          } else {
            arabic = verses.join('\n\n');
          }
        },
      );

      enChapter.fold(
        (Failure f) => AppLogger.error('Failed to load English gospel: ${f.message}'),
        (List<String> verses) {
          if (verses.length >= 17) {
            english = verses.sublist(0, 17).join('\n\n');
          } else {
            english = verses.join('\n\n');
          }
        },
      );

      return Right<Failure, GospelModel>(
        GospelModel(
          arabic: arabic,
          english: english,
          coptic: fallbackGospelCoptic,
          reference: 'John 1:1-17',
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to fetch local gospel', error: e, stack: stack);
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
}
