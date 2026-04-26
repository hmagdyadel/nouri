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
        (_) => const CompetitionLoaded(<Map<String, Object>>[]),
        (entries) => CompetitionLoaded(
          entries
              .map(
                (e) => <String, Object>{
                  'name': e.name,
                  'church': 'كنيستي',
                  'points': e.points,
                },
              )
              .toList(),
        ),
      ),
    );
  }
}
