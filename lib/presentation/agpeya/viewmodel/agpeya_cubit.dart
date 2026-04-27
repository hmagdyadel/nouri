import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/data/repositories/agpeya_repository.dart';
import 'package:agpeya/data/repositories/prayer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'agpeya_state.dart';

class AgpeyaCubit extends Cubit<AgpeyaState> {
  AgpeyaCubit({PrayerRepository? repository, AgpeyaRepository? agpeyaRepository})
      : _repository = repository ?? getIt<PrayerRepository>(),
        _agpeyaRepository = agpeyaRepository ?? getIt<AgpeyaRepository>(),
        super(AgpeyaInitial());

  final PrayerRepository _repository;
  final AgpeyaRepository _agpeyaRepository;
  final Map<String, Map<String, bool>> languageAvailability = <String, Map<String, bool>>{};

  Future<void> loadHours() async {
    AppLogger.cubit('AgpeyaCubit', 'AgpeyaLoading');
    emit(AgpeyaLoading());
    final result = await _repository.getCompletedHoursToday();
    final List<int> completed = result.fold((_) => <int>[], (List<int> r) => r);
    for (final PrayerHourData h in agpeyaHours) {
      languageAvailability[_mapHourToId(h.hour)] = await _agpeyaRepository.availability(_mapHourToId(h.hour));
    }
    AppLogger.cubit('AgpeyaCubit', 'AgpeyaLoaded', data: <String, dynamic>{'completed': completed.length});
    emit(AgpeyaLoaded(agpeyaHours, completed));
  }

  Future<void> openHour(PrayerHourData hour) async {
    await switchLanguage('ar', _mapHourToId(hour.hour));
  }

  Future<void> switchLanguage(String lang, String hourId) async {
    AppLogger.cubit(
      'AgpeyaCubit',
      'SwitchLanguage',
      data: <String, dynamic>{'lang': lang, 'hour': hourId},
    );
    emit(AgpeyaReaderLoading());
    final result = await _agpeyaRepository.getHour(hourId, lang);
    result.fold(
      (failure) {
        AppLogger.error('Language switch failed', error: failure);
        emit(AgpeyaReaderError(failure.message));
      },
      (hourResult) {
        AppLogger.success('Language switched', data: <String, dynamic>{'lang': hourResult.lang});
        emit(
          AgpeyaReaderLoaded(
            hour: hourResult.hour,
            currentLang: hourResult.lang,
            fallbackUsed: hourResult.fallbackUsed,
          ),
        );
      },
    );
  }

  Future<bool> completeHour(int hour) async {
    AppLogger.info('Completing Agpeya hour', data: <String, dynamic>{'hour': hour});
    final result = await _repository.logPrayer(hour);
    if (result.isLeft()) {
      AppLogger.error('Failed to complete hour');
      return false;
    }
    AppLogger.success('Hour completed successfully');
    await loadHours();
    return true;
  }

  String _mapHourToId(int hour) {
    switch (hour) {
      case 1:
        return 'prime';
      case 3:
        return 'terce';
      case 6:
        return 'sext';
      case 9:
        return 'none';
      case 11:
        return 'vespers';
      case 12:
        return 'compline';
      default:
        return 'midnight';
    }
  }
}
