import 'package:equatable/equatable.dart';

class GospelModel extends Equatable {
  const GospelModel({
    required this.arabic,
    required this.english,
    required this.coptic,
    this.reference = '',
  });

  final String arabic;
  final String english;
  final String coptic;
  final String reference;

  @override
  List<Object> get props => <Object>[arabic, english, coptic, reference];
}
