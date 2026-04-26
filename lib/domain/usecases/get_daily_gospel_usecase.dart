import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/models/gospel_model.dart';
import 'package:agpeya/data/repositories/gospel_repository.dart';
import 'package:dartz/dartz.dart';

class GetDailyGospelUseCase {
  GetDailyGospelUseCase(this._repository);
  final GospelRepository _repository;

  Future<Either<Failure, GospelModel>> call() {
    return _repository.getDailyGospel();
  }
}
