import 'package:equatable/equatable.dart';

class PrayerLogModel extends Equatable {
  const PrayerLogModel({
    required this.dateKey,
    required this.hoursCompleted,
    required this.gospelRead,
    required this.pointsEarned,
  });

  final String dateKey;
  final List<int> hoursCompleted;
  final bool gospelRead;
  final int pointsEarned;

  @override
  List<Object> get props => <Object>[dateKey, hoursCompleted, gospelRead, pointsEarned];
}
