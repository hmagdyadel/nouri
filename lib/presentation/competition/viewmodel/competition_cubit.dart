import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/domain/usecases/get_leaderboard_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'competition_state.dart';

class CompetitionCubit extends Cubit<CompetitionState> {
  CompetitionCubit({GetLeaderboardUseCase? useCase})
      : _useCase = useCase ?? getIt<GetLeaderboardUseCase>(),
        super(CompetitionInitial());

  final GetLeaderboardUseCase _useCase;

  Future<void> load() async {
    emit(CompetitionLoading());
    final result = await _useCase();
    emit(
      result.fold(
        (_) => CompetitionLoaded(
          entries: const <Map<String, Object>>[],
          period: CompetitionPeriod.weekly,
          scope: CompetitionScope.global,
          nextReset: _nextSundayMidnight(),
        ),
        (entries) => CompetitionLoaded(
          entries: entries
              .map(
                (e) => <String, Object>{
                  'name': e.name,
                  'church': 'كنيستي',
                  'points': e.points,
                },
              )
              .toList(),
          period: CompetitionPeriod.weekly,
          scope: CompetitionScope.global,
          nextReset: _nextSundayMidnight(),
        ),
      ),
    );
  }

  void setPeriod(CompetitionPeriod period) {
    if (state is! CompetitionLoaded) return;
    final CompetitionLoaded loaded = state as CompetitionLoaded;
    final DateTime reset = switch (period) {
      CompetitionPeriod.weekly => _nextSundayMidnight(),
      CompetitionPeriod.monthly => _nextMonthStartMidnight(),
      CompetitionPeriod.allTime => _nextSundayMidnight(),
    };
    emit(loaded.copyWith(period: period, nextReset: reset));
  }

  void setScope(CompetitionScope scope) {
    if (state is! CompetitionLoaded) return;
    final CompetitionLoaded loaded = state as CompetitionLoaded;
    emit(loaded.copyWith(scope: scope));
  }

  DateTime _nextSundayMidnight() {
    final DateTime now = DateTime.now();
    int add = DateTime.sunday - now.weekday;
    if (add <= 0) add += 7;
    return DateTime(now.year, now.month, now.day).add(Duration(days: add));
  }

  DateTime _nextMonthStartMidnight() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month + 1, 1);
  }
}
