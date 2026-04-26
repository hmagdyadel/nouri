import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/repositories/prayer_repository.dart';
import 'package:dartz/dartz.dart';

class LogPrayerUseCase {
  LogPrayerUseCase(this.repository);
  final PrayerRepository repository;

  Future<Either<Failure, void>> call(int hour) => repository.logPrayer(hour);
}
