import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/sources/local/prayer_local_source.dart';
import 'package:agpeya/data/sources/remote/agpeya_api_source.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

abstract class PrayerRepository {
  Future<Either<Failure, String>> getPrayerHourContent(int hour);
  Future<Either<Failure, void>> logPrayer(int hour);
  Future<Either<Failure, List<int>>> getCompletedHoursToday();
}

class PrayerRepositoryImpl implements PrayerRepository {
  PrayerRepositoryImpl({
    required AgpeyaApiSource apiSource,
    required PrayerLocalSource localSource,
    required FirebaseRemoteSource firebaseSource,
    required FirebaseFunctions functions,
  })  : _apiSource = apiSource,
        _localSource = localSource,
        _firebaseSource = firebaseSource,
        _functions = functions;

  final AgpeyaApiSource _apiSource;
  final PrayerLocalSource _localSource;
  final FirebaseRemoteSource _firebaseSource;
  final FirebaseFunctions _functions;

  @override
  Future<Either<Failure, String>> getPrayerHourContent(int hour) async {
    final String key = _cacheKey(hour);
    final String? local = _localSource.getPrayer(key);
    if (local != null && local.isNotEmpty) return Right<Failure, String>(local);
    try {
      final String remote = await _apiSource.getPrayerContent(hour);
      await _localSource.cachePrayer(key, remote);
      return Right<Failure, String>(remote);
    } catch (e) {
      return Left<Failure, String>(ServerFailure('Failed to load prayer: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logPrayer(int hour) async {
    if (_firebaseSource.currentUid == null) {
      await _saveGuestPrayer(hour);
      return const Right<Failure, void>(null);
    }
    try {
      final HttpsCallable callable = _functions.httpsCallable('logPrayerCallable');
      await callable.call(<String, dynamic>{'hour': hour});
      return const Right<Failure, void>(null);
    } catch (e) {
      return Left<Failure, void>(ServerFailure('Failed to log prayer: $e'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getCompletedHoursToday() async {
    try {
      final String key = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (_firebaseSource.currentUid == null) {
        return Right<Failure, List<int>>(_readGuestPrayers(key));
      }
      final List<int> result = await _firebaseSource.getTodayCompletedHours(key);
      return Right<Failure, List<int>>(result);
    } catch (e) {
      return Left<Failure, List<int>>(ServerFailure('Failed to load progress: $e'));
    }
  }

  String _cacheKey(int hour) {
    final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return 'prayer_hour_${hour}_$date';
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
