import 'package:agpeya/data/models/bible_api_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'bible_api_service.g.dart';

@RestApi(baseUrl: 'https://bible.helloao.org/api')
abstract class BibleApiService {
  factory BibleApiService(Dio dio, {String baseUrl}) = _BibleApiService;

  @GET('/{translation}/{book}/{chapter}.json')
  Future<ChapterResponseWrapper> getChapter(
    @Path() String translation,
    @Path() String book,
    @Path() int chapter,
  );
}
