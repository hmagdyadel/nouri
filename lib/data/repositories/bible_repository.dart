import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/models/bible_model.dart';
import 'package:agpeya/data/sources/local/bible_local_source.dart';
import 'package:dartz/dartz.dart';

class BibleRepository {
  BibleRepository(this._localSource);
  final BibleLocalSource _localSource;

  Future<Either<Failure, BibleBookModel>> getBook(String abbrev, String lang) async {
    try {
      final BibleBookModel? book = await _localSource.getBook(abbrev, lang);
      if (book != null) {
        return Right<Failure, BibleBookModel>(book);
      }
      return Left<Failure, BibleBookModel>(CacheFailure('Book not found: $abbrev'));
    } catch (e, stack) {
      AppLogger.error('BibleRepository.getBook failed', error: e, stack: stack);
      return Left<Failure, BibleBookModel>(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<String>>> getChapter(String abbrev, int chapter, String lang) async {
    try {
      final List<String>? verses = await _localSource.getChapter(abbrev, chapter, lang);
      if (verses != null) {
        return Right<Failure, List<String>>(verses);
      }
      return Left<Failure, List<String>>(CacheFailure('Chapter not found: $abbrev $chapter'));
    } catch (e, stack) {
      AppLogger.error('BibleRepository.getChapter failed', error: e, stack: stack);
      return Left<Failure, List<String>>(CacheFailure(e.toString()));
    }
  }
}
