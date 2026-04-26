import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:equatable/equatable.dart';

sealed class AgpeyaState extends Equatable {
  const AgpeyaState();
  @override
  List<Object?> get props => <Object?>[];
}

class AgpeyaInitial extends AgpeyaState {}

class AgpeyaLoading extends AgpeyaState {}

class AgpeyaLoaded extends AgpeyaState {
  const AgpeyaLoaded(this.hours, this.completedToday);
  final List<PrayerHourData> hours;
  final List<int> completedToday;
  @override
  List<Object> get props => <Object>[hours, completedToday];
}

class PrayerReading extends AgpeyaState {
  const PrayerReading(this.content, this.currentSection, this.isAudioPlaying);
  final String content;
  final int currentSection;
  final bool isAudioPlaying;
  @override
  List<Object> get props => <Object>[content, currentSection, isAudioPlaying];
}

class PrayerCompleted extends AgpeyaState {
  const PrayerCompleted(this.pointsEarned, this.newStreak);
  final int pointsEarned;
  final int newStreak;
  @override
  List<Object> get props => <Object>[pointsEarned, newStreak];
}
