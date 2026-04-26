import 'package:equatable/equatable.dart';

class LeaderboardEntity extends Equatable {
  const LeaderboardEntity({
    required this.uid,
    required this.name,
    required this.points,
    required this.rank,
  });

  final String uid;
  final String name;
  final int points;
  final int rank;

  @override
  List<Object> get props => <Object>[uid, name, points, rank];
}
