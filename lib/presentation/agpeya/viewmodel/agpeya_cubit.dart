import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/data/repositories/prayer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'agpeya_state.dart';

class AgpeyaCubit extends Cubit<AgpeyaState> {
  AgpeyaCubit({PrayerRepository? repository})
      : _repository = repository ?? getIt<PrayerRepository>(),
        super(AgpeyaInitial());

  final PrayerRepository _repository;

  Future<void> loadHours() async {
    AppLogger.cubit('AgpeyaCubit', 'AgpeyaLoading');
    emit(AgpeyaLoading());
    final result = await _repository.getCompletedHoursToday();
    final List<int> completed = result.fold((_) => <int>[], (List<int> r) => r);
    AppLogger.cubit('AgpeyaCubit', 'AgpeyaLoaded', data: <String, dynamic>{'completed': completed.length});
    emit(AgpeyaLoaded(agpeyaHours, completed));
  }

  Future<List<String>> openHour(PrayerHourData hour) async {
    AppLogger.info('Opening Agpeya hour', data: <String, dynamic>{'hour': hour.hour});
    final content = await _repository.getPrayerHourContent(hour.hour);
    return content.fold(
      (_) {
        AppLogger.warning('Using fallback for prayer hour', data: <String, dynamic>{'hour': hour.hour});
        return <String>[
          firstHourFallbackArabic,
          fallbackPrayerEnglishByHour[hour.hour] ?? 'Prayer not available.',
          fallbackPrayerCopticByHour[hour.hour] ?? fallbackGospelCoptic,
        ];
      },
      (List<String> c) => c,
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
}
