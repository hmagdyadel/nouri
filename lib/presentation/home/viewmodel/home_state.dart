import 'package:equatable/equatable.dart';

class HomeStats extends Equatable {
  const HomeStats({
    required this.streak,
    required this.rank,
    required this.pointsToday,
  });
  final int streak;
  final int rank;
  final int pointsToday;

  @override
  List<Object> get props => <Object>[streak, rank, pointsToday];
}

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => <Object?>[];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.greeting,
    required this.copticDate,
    required this.displayName,
    required this.username,
    required this.isGuest,
    required this.cardArabic,
    required this.cardEnglish,
    required this.cardCoptic,
    required this.progressHours,
    required this.stats,
  });
  final String greeting;
  final String copticDate;
  final String? displayName;
  final String? username;
  final bool isGuest;
  final String cardArabic;
  final String cardEnglish;
  final String cardCoptic;
  final List<int> progressHours;
  final HomeStats stats;

  @override
  List<Object?> get props => <Object?>[
        cardArabic,
        cardEnglish,
        cardCoptic,
        greeting,
        copticDate,
        displayName,
        username,
        isGuest,
        progressHours,
        stats,
      ];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;

  @override
  List<Object> get props => <Object>[message];
}
