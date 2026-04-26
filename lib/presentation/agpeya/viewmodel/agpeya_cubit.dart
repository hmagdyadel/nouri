import 'package:agpeya/core/constants/prayer_data.dart';
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
    emit(AgpeyaLoading());
    final result = await _repository.getCompletedHoursToday();
    final List<int> completed = result.fold((_) => <int>[], (List<int> r) => r);
    emit(AgpeyaLoaded(agpeyaHours, completed));
  }

  Future<String> openHour(PrayerHourData hour) async {
    final content = await _repository.getPrayerHourContent(hour.hour);
    return content.fold((_) => firstHourFallbackArabic, (String c) => c);
  }

  Future<bool> completeHour(int hour) async {
    final result = await _repository.logPrayer(hour);
    if (result.isLeft()) return false;
    await loadHours();
    return true;
  }
}
