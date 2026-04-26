import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/data/sources/local/prayer_local_source.dart';
import 'package:agpeya/data/sources/remote/agpeya_api_source.dart';
import 'package:agpeya/data/sources/local/agpeya_local_source.dart';
import 'package:agpeya/data/models/agpeya_section.dart';
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
    required AgpeyaApiSource apiSource,
    required AgpeyaLocalSource localAgpeyaSource,
    required PrayerLocalSource localSource,
    required FirebaseRemoteSource firebaseSource,
    required FirebaseFunctions functions,
  })  : _apiSource = apiSource,
        _localAgpeyaSource = localAgpeyaSource,
        _localSource = localSource,
        _firebaseSource = firebaseSource,
        _functions = functions;

  final AgpeyaApiSource _apiSource;
  final AgpeyaLocalSource _localAgpeyaSource;
  final PrayerLocalSource _localSource;
  final FirebaseRemoteSource _firebaseSource;
  final FirebaseFunctions _functions;

  @override
  Future<Either<Failure, List<String>>> getPrayerHourContent(int hour) async {
    AppLogger.info('Fetching prayer hour content', data: <String, dynamic>{'hour': hour});
    try {
      // 1. Fetch Arabic from Local JSON
      final List<AgpeyaSection> arabicSections = await _localAgpeyaSource.getPrayerContent(hour, 0);
      final String arabic = _renderSections(arabicSections);

      // 2. Fetch English from Local JSON
      final List<AgpeyaSection> englishSections = await _localAgpeyaSource.getPrayerContent(hour, 1);
      final String english = _renderSections(englishSections);

      // 3. Fetch Coptic from Local JSON
      final List<AgpeyaSection> copticSections = await _localAgpeyaSource.getPrayerContent(hour, 2);
      final String coptic = _renderSections(copticSections);
      
      AppLogger.success('Prayer hour fetched successfully', data: <String, dynamic>{'hour': hour});
      
      return Right<Failure, List<String>>(<String>[arabic, english, coptic]);
    } catch (e, stack) {
      AppLogger.error('Failed to get prayer hour', error: e, stack: stack);
      return Left<Failure, List<String>>(ServerFailure('Failed to load prayer: $e'));
    }
  }

  String _renderSections(List<AgpeyaSection> sections) {
    if (sections.isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (final AgpeyaSection section in sections) {
      buffer.writeln('## ${section.title}');
      if (section.subtitle != null) buffer.writeln('*${section.subtitle}*');
      buffer.writeln();
      buffer.writeln(section.content);
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }
    return buffer.toString().trim();
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
