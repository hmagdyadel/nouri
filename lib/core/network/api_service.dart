import 'package:dio/dio.dart';

class AgpeyaApiService {
  AgpeyaApiService(this._dio);
  final Dio _dio;

  Future<Response<String>> getPrayerHourHtml(String hour) {
    return _dio.get<String>('https://st-takla.org/Agpeya/$hour');
  }

  Future<Response<String>> getDailyGospelHtml() {
    return _dio.get<String>('https://st-takla.org/bible/daily');
  }
}
