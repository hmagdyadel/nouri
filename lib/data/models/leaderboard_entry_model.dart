import 'package:equatable/equatable.dart';

class LeaderboardEntryModel extends Equatable {
  const LeaderboardEntryModel({
    required this.uid,
    required this.name,
    required this.points,
    required this.rank,
    required this.streak,
  });

  final String uid;
  final String name;
  final int points;
  final int rank;
  final int streak;

  @override
  List<Object> get props => <Object>[uid, name, points, rank, streak];
}
