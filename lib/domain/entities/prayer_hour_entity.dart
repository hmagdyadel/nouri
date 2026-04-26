import 'package:equatable/equatable.dart';

class PrayerHourEntity extends Equatable {
  const PrayerHourEntity({
    required this.hour,
    required this.nameAr,
    required this.nameEn,
  });

  final int hour;
  final String nameAr;
  final String nameEn;

  @override
  List<Object> get props => <Object>[hour, nameAr, nameEn];
}
