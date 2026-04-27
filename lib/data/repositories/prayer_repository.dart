import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/sources/local/prayer_local_source.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

abstract class PrayerRepository {
  Future<Either<Failure, List<String>>> getPrayerHourContent(int hour);
  Future<Either<Failure, void>> logPrayer(int hour);
  Future<Either<Failure, List<int>>> getCompletedHoursToday();
}

class PrayerRepositoryImpl implements PrayerRepository {
  PrayerRepositoryImpl({
    required PrayerLocalSource localSource,
    required FirebaseRemoteSource firebaseSource,
    required FirebaseFunctions functions,
  })  : _localSource = localSource,
        _firebaseSource = firebaseSource,
        _functions = functions;

  final PrayerLocalSource _localSource;
  final FirebaseRemoteSource _firebaseSource;
  final FirebaseFunctions _functions;

  @override
  Future<Either<Failure, List<String>>> getPrayerHourContent(int hour) async {
    return const Left<Failure, List<String>>(
      CacheFailure('Deprecated: use AgpeyaRepository local structured model'),
    );
  }

  @override
  Future<Either<Failure, void>> logPrayer(int hour) async {
    AppLogger.info('Logging prayer', data: <String, dynamic>{'hour': hour, 'isGuest': _firebaseSource.currentUid == null});
    if (_firebaseSource.currentUid == null) {
      await _saveGuestPrayer(hour);
      AppLogger.success('Guest prayer logged', data: <String, dynamic>{'hour': hour});
      return const Right<Failure, void>(null);
    }
    try {
      final HttpsCallable callable = _functions.httpsCallable('logPrayerCallable');
      await callable.call(<String, dynamic>{'hour': hour});
      AppLogger.firebase('Prayer log written to Firebase', data: <String, dynamic>{'hour': hour});
      return const Right<Failure, void>(null);
    } catch (e, stack) {
      AppLogger.error('Failed to log prayer', error: e, stack: stack);
      return Left<Failure, void>(ServerFailure('Failed to log prayer: $e'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getCompletedHoursToday() async {
    AppLogger.info('Fetching completed hours today');
    try {
      final String key = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (_firebaseSource.currentUid == null) {
        final List<int> result = _readGuestPrayers(key);
        AppLogger.hive('Read guest completed hours', box: 'local', key: key, value: result);
        return Right<Failure, List<int>>(result);
      }
      final List<int> result = await _firebaseSource.getTodayCompletedHours(key);
      AppLogger.firebase('Fetched completed hours from Firebase', data: <String, dynamic>{'result': result});
      return Right<Failure, List<int>>(result);
    } catch (e, stack) {
      AppLogger.error('Failed to fetch completed hours', error: e, stack: stack);
      return Left<Failure, List<int>>(ServerFailure('Failed to load progress: $e'));
    }
  }

  Future<void> _saveGuestPrayer(int hour) async {
    final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final List<int> current = _readGuestPrayers(date);
    if (!current.contains(hour)) current.add(hour);
    await _localSource.cachePrayer('guest_logs_$date', current.join(','));
  }

  List<int> _readGuestPrayers(String date) {
    final String? raw = _localSource.getPrayer('guest_logs_$date');
    if (raw == null || raw.isEmpty) return <int>[];
    return raw
        .split(',')
        .map((String e) => int.tryParse(e) ?? -1)
        .where((int e) => e >= 0)
        .toSet()
        .toList();
  }
}
