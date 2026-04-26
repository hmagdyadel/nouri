import 'package:agpeya/core/logger/app_logger.dart';
import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    AppLogger.api(
      '⬆️ ${options.method} ${options.path}',
      url: options.uri.toString(),
      method: options.method,
      requestBody: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final DateTime? start = response.requestOptions.extra['startTime'] as DateTime?;
    final Duration? duration = start != null ? DateTime.now().difference(start) : null;
    AppLogger.api(
      '✅ ${response.statusCode} ${response.requestOptions.path}',
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      statusCode: response.statusCode,
      responseBody: response.data,
      duration: duration,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '❌ ${err.response?.statusCode ?? 'NO_RESPONSE'} ${err.requestOptions.path}',
      error: err.message,
    );
    handler.next(err);
  }
}
