import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/models/leaderboard_entry_model.dart';
import 'package:agpeya/data/repositories/leaderboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetLeaderboardUseCase {
  GetLeaderboardUseCase(this._repository);
  final LeaderboardRepository _repository;

  Future<Either<Failure, List<LeaderboardEntryModel>>> call() {
    return _repository.getWeekly();
  }
}
