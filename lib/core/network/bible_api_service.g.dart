// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _BibleApiService implements BibleApiService {
  _BibleApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://bible.helloao.org/api';
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<ChapterResponseWrapper> getChapter(
    String translation,
    String book,
    int chapter,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$baseUrl/$translation/$book/$chapter.json',
    );
    return ChapterResponseWrapper.fromJson(response.data ?? <String, dynamic>{});
  }
}
