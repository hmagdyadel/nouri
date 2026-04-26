import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'agpeya_api_service.g.dart';

@RestApi(baseUrl: 'https://api.coptic.io/api')
abstract class AgpeyaApiService {
  factory AgpeyaApiService(Dio dio, {String baseUrl}) = _AgpeyaApiService;

  @GET('/agpeya/{hour}')
  Future<Map<String, dynamic>> getPrayerHour(@Path() String hour);
}
