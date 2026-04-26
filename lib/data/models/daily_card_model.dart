import 'package:equatable/equatable.dart';

class DailyCardModel extends Equatable {
  const DailyCardModel({
    required this.arabic,
    required this.english,
    required this.coptic,
    required this.reference,
  });

  final String arabic;
  final String english;
  final String coptic;
  final String reference;

  @override
  List<Object> get props => <Object>[arabic, english, coptic, reference];
}
