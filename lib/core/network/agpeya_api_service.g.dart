// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agpeya_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AgpeyaApiService implements AgpeyaApiService {
  _AgpeyaApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.coptic.io/api';
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<Map<String, dynamic>> getPrayerHour(String hour) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$baseUrl/agpeya/$hour',
    );
    return response.data ?? <String, dynamic>{};
  }
}
