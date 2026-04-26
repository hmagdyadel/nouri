import 'package:equatable/equatable.dart';

sealed class GospelState extends Equatable {
  const GospelState();
  @override
  List<Object?> get props => <Object?>[];
}

class GospelInitial extends GospelState {}
class GospelLoading extends GospelState {}

class GospelLoaded extends GospelState {
  const GospelLoaded(this.ar, this.en, this.cop);
  final String ar;
  final String en;
  final String cop;
  @override
  List<Object> get props => <Object>[ar, en, cop];
}
