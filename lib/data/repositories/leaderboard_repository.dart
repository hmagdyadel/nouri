import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/models/leaderboard_entry_model.dart';
import 'package:dartz/dartz.dart';

class LeaderboardRepository {
  Future<Either<Failure, List<LeaderboardEntryModel>>> getWeekly() async {
    return const Right<Failure, List<LeaderboardEntryModel>>(
      <LeaderboardEntryModel>[
        LeaderboardEntryModel(uid: '1', name: 'مينا', points: 120, rank: 1, streak: 5),
        LeaderboardEntryModel(uid: '2', name: 'كيرلس', points: 95, rank: 2, streak: 4),
      ],
    );
  }
}
