import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/models/agpeya_model.dart';
import 'package:agpeya/data/sources/local/agpeya_local_source.dart';
import 'package:dartz/dartz.dart';

class AgpeyaRepository {
  AgpeyaRepository(this._local);
  final AgpeyaLocalSource _local;

  Future<Either<Failure, AgpeyaHourResult>> getHour(String hourId, String lang) async {
    try {
      final AgpeyaHourModel? hour = await _local.getHour(hourId, lang);
      if (hour == null) {
        AppLogger.warning(
          'Falling back to Arabic for missing lang',
          data: <String, dynamic>{'hour': hourId, 'lang': lang},
        );
        final AgpeyaHourModel? arHour = await _local.getHour(hourId, 'ar');
        if (arHour == null) return Left<Failure, AgpeyaHourResult>(CacheFailure('Hour not found'));
        return Right<Failure, AgpeyaHourResult>(
          AgpeyaHourResult(hour: arHour, lang: 'ar', fallbackUsed: true),
        );
      }
      return Right<Failure, AgpeyaHourResult>(
        AgpeyaHourResult(hour: hour, lang: lang, fallbackUsed: false),
      );
    } catch (e, stack) {
      AppLogger.error('AgpeyaRepository.getHour failed', error: e, stack: stack);
      return Left<Failure, AgpeyaHourResult>(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<AgpeyaHourModel>>> getAllHours(String lang) async {
    try {
      final List<AgpeyaHourModel> hours = await _local.getAllHours(lang);
      if (hours.length < 7) {
        AppLogger.warning(
          'Incomplete file, supplementing from Arabic',
          data: <String, dynamic>{'lang': lang, 'found': hours.length},
        );
      }
      return Right<Failure, List<AgpeyaHourModel>>(hours);
    } catch (e, stack) {
      AppLogger.error('AgpeyaRepository.getAllHours failed', error: e, stack: stack);
      try {
        final List<AgpeyaHourModel> arHours = await _local.getAllHours('ar');
        return Right<Failure, List<AgpeyaHourModel>>(arHours);
      } catch (e2) {
        return Left<Failure, List<AgpeyaHourModel>>(CacheFailure(e2.toString()));
      }
    }
  }

  Future<Map<String, bool>> availability(String hourId) async {
    final AgpeyaHourModel? ar = await _local.getHour(hourId, 'ar');
    final AgpeyaHourModel? en = await _local.getHour(hourId, 'en');
    final AgpeyaHourModel? cop = await _local.getHour(hourId, 'cop');
    return <String, bool>{
      'ar': ar != null,
      'en': en != null,
      'cop': cop != null,
    };
  }
}

class AgpeyaHourResult {
  AgpeyaHourResult({
    required this.hour,
    required this.lang,
    required this.fallbackUsed,
  });
  final AgpeyaHourModel hour;
  final String lang;
  final bool fallbackUsed;
}
