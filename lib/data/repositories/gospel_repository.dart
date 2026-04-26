import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/data/models/gospel_model.dart';
import 'package:dartz/dartz.dart';

class GospelRepository {
  Future<Either<Failure, GospelModel>> getDailyGospel() async {
    return const Right<Failure, GospelModel>(
      GospelModel(
        arabic: 'إنجيل اليوم',
        english: 'Daily Gospel',
        coptic: 'Ⲡⲓⲉⲩⲁⲅⲅⲉⲗⲓⲟⲛ',
      ),
    );
  }
}
