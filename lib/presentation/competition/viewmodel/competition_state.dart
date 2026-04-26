import 'package:equatable/equatable.dart';

sealed class CompetitionState extends Equatable {
  const CompetitionState();
  @override
  List<Object?> get props => <Object?>[];
}

class CompetitionInitial extends CompetitionState {}
class CompetitionLoading extends CompetitionState {}
class CompetitionLoaded extends CompetitionState {
  const CompetitionLoaded(this.entries);
  final List<Map<String, Object>> entries;
  @override
  List<Object> get props => <Object>[entries];
}
class CompetitionError extends CompetitionState {
  const CompetitionError(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}
