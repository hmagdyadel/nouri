import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer_log_model.g.dart';

@HiveType(typeId: 102)
@JsonSerializable()
class PrayerLogModel extends Equatable {
  const PrayerLogModel({
    required this.dateKey,
    required this.hoursCompleted,
    required this.gospelRead,
    required this.pointsEarned,
  });

  @HiveField(0)
  final String dateKey;
  @HiveField(1)
  final List<int> hoursCompleted;
  @HiveField(2)
  final bool gospelRead;
  @HiveField(3)
  final int pointsEarned;

  factory PrayerLogModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerLogModelToJson(this);

  @override
  List<Object> get props => <Object>[dateKey, hoursCompleted, gospelRead, pointsEarned];
}
