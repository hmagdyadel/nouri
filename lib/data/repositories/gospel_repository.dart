import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/network/api_service.dart';
import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/data/models/gospel_model.dart';
import 'package:dartz/dartz.dart';
import 'package:html/parser.dart' as html_parser;

class GospelRepository {
  GospelRepository(this._apiService);
  final AgpeyaApiService _apiService;

  Future<Either<Failure, GospelModel>> getDailyGospel() async {
    try {
      final response = await _apiService.getDailyGospelHtml();
      final document = html_parser.parse(response.data ?? '');
      final String extracted =
          (document.body?.text ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
      if (extracted.length < 60) {
        return const Right<Failure, GospelModel>(
          GospelModel(
            arabic: fallbackGospelArabic,
            english: fallbackGospelEnglish,
            coptic: fallbackGospelCoptic,
          ),
        );
      }
      return Right<Failure, GospelModel>(
        GospelModel(
          arabic: extracted,
          english: fallbackGospelEnglish,
          coptic: fallbackGospelCoptic,
        ),
      );
    } catch (_) {
      return const Right<Failure, GospelModel>(
        GospelModel(
          arabic: fallbackGospelArabic,
          english: fallbackGospelEnglish,
          coptic: fallbackGospelCoptic,
        ),
      );
    }
  }
}
