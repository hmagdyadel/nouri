import 'package:equatable/equatable.dart';

sealed class GospelState extends Equatable {
  const GospelState();
  @override
  List<Object?> get props => <Object?>[];
}

class GospelInitial extends GospelState {}
class GospelLoading extends GospelState {}

class GospelLoaded extends GospelState {
  const GospelLoaded({
    required this.ar,
    required this.en,
    required this.cop,
    required this.readToday,
    this.highlightedVerse,
  });
  final String ar;
  final String en;
  final String cop;
  final bool readToday;
  final int? highlightedVerse;

  GospelLoaded copyWith({
    String? ar,
    String? en,
    String? cop,
    bool? readToday,
    int? highlightedVerse,
    bool clearHighlight = false,
  }) {
    return GospelLoaded(
      ar: ar ?? this.ar,
      en: en ?? this.en,
      cop: cop ?? this.cop,
      readToday: readToday ?? this.readToday,
      highlightedVerse: clearHighlight ? null : (highlightedVerse ?? this.highlightedVerse),
    );
  }

  @override
  List<Object?> get props => <Object?>[ar, en, cop, readToday, highlightedVerse];
}
