import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/models/leaderboard_entry_model.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:dartz/dartz.dart';

class LeaderboardRepository {
  LeaderboardRepository(this._remoteSource);
  final FirebaseRemoteSource _remoteSource;

  Future<Either<Failure, List<LeaderboardEntryModel>>> getWeekly() async {
    AppLogger.info('Fetching weekly leaderboard');
    try {
      final List<Map<String, dynamic>> data = await _remoteSource.getLeaderboard();
      final List<LeaderboardEntryModel> entries = data.map((Map<String, dynamic> m) {
        return LeaderboardEntryModel(
          uid: m['uid'] as String? ?? '',
          name: m['name'] as String? ?? 'User',
          points: m['points'] as int? ?? 0,
          rank: m['rank'] as int? ?? 0,
          streak: m['streak'] as int? ?? 0,
        );
      }).toList();
      
      AppLogger.success('Leaderboard entries parsed', data: <String, dynamic>{'count': entries.length});
      return Right<Failure, List<LeaderboardEntryModel>>(entries);
    } catch (e, stack) {
      AppLogger.error('Failed to fetch leaderboard', error: e, stack: stack);
      return Left<Failure, List<LeaderboardEntryModel>>(ServerFailure('Failed to fetch leaderboard: $e'));
    }
  }
}
