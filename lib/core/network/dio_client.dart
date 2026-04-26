import 'package:agpeya/core/network/logger_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.add(LoggerInterceptor());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) => handler.next(options),
        onError: (DioException error, ErrorInterceptorHandler handler) => handler.next(error),
      ),
    );
    return dio;
  }
}
