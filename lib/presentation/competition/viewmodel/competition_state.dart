import 'package:equatable/equatable.dart';

enum CompetitionPeriod { weekly, monthly, allTime }

enum CompetitionScope { global, church, family }

sealed class CompetitionState extends Equatable {
  const CompetitionState();
  @override
  List<Object?> get props => <Object?>[];
}

class CompetitionInitial extends CompetitionState {}
class CompetitionLoading extends CompetitionState {}
class CompetitionLoaded extends CompetitionState {
  const CompetitionLoaded({
    required this.entries,
    required this.period,
    required this.scope,
    required this.nextReset,
  });
  final List<Map<String, Object>> entries;
  final CompetitionPeriod period;
  final CompetitionScope scope;
  final DateTime nextReset;

  CompetitionLoaded copyWith({
    List<Map<String, Object>>? entries,
    CompetitionPeriod? period,
    CompetitionScope? scope,
    DateTime? nextReset,
  }) {
    return CompetitionLoaded(
      entries: entries ?? this.entries,
      period: period ?? this.period,
      scope: scope ?? this.scope,
      nextReset: nextReset ?? this.nextReset,
    );
  }

  @override
  List<Object> get props => <Object>[entries, period, scope, nextReset];
}
class CompetitionError extends CompetitionState {
  const CompetitionError(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}
