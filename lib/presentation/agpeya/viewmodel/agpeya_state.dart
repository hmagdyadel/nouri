import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/data/models/agpeya_model.dart';
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

class AgpeyaReaderLoading extends AgpeyaState {}

class AgpeyaReaderError extends AgpeyaState {
  const AgpeyaReaderError(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}

class AgpeyaReaderLoaded extends AgpeyaState {
  const AgpeyaReaderLoaded({
    required this.hour,
    required this.currentLang,
    required this.fallbackUsed,
  });
  final AgpeyaHourModel hour;
  final String currentLang;
  final bool fallbackUsed;
  @override
  List<Object> get props => <Object>[hour, currentLang, fallbackUsed];
}
