import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

enum LogType { api, success, error, warning, info, hive, firebase, navigation, cubit }

class LogEntry {
  final String id;
  final LogType type;
  final String message;
  final DateTime timestamp;
  final String? url;
  final String? method;
  final int? statusCode;
  final String? requestBody;
  final String? responseBody;
  final String? data;
  final String? error;
  final String? stackTrace;
  final Duration? duration;
  final String? hiveBox;
  final String? hiveKey;

  const LogEntry({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    this.url,
    this.method,
    this.statusCode,
    this.requestBody,
    this.responseBody,
    this.data,
    this.error,
    this.stackTrace,
    this.duration,
    this.hiveBox,
    this.hiveKey,
  });
}

class AppLogger {
  static final List<LogEntry> _logs = <LogEntry>[];
  static final StreamController<List<LogEntry>> _controller = StreamController<List<LogEntry>>.broadcast();

  static Stream<List<LogEntry>> get stream => _controller.stream;
  static List<LogEntry> get logs => List<LogEntry>.unmodifiable(_logs);

  static void api(
    String message, {
    String? url,
    String? method,
    int? statusCode,
    dynamic requestBody,
    dynamic responseBody,
    Duration? duration,
  }) =>
      _log(
        LogType.api,
        message,
        url: url,
        method: method,
        statusCode: statusCode,
        requestBody: requestBody,
        responseBody: responseBody,
        duration: duration,
      );

  static void success(String message, {dynamic data}) =>
      _log(LogType.success, message, data: data);

  static void error(String message, {dynamic error, StackTrace? stack}) =>
      _log(LogType.error, message, error: error, stackTrace: stack);

  static void warning(String message, {dynamic data}) =>
      _log(LogType.warning, message, data: data);

  static void info(String message, {dynamic data}) =>
      _log(LogType.info, message, data: data);

  static void hive(String message, {String? box, String? key, dynamic value}) =>
      _log(LogType.hive, message, box: box, key: key, data: value);

  static void firebase(String message, {dynamic data}) =>
      _log(LogType.firebase, message, data: data);

  static void navigation(String message) => _log(LogType.navigation, message);

  static void cubit(String cubitName, String state, {dynamic data}) =>
      _log(LogType.cubit, '$cubitName → $state', data: data);

  static void _log(
    LogType type,
    String message, {
    String? url,
    String? method,
    int? statusCode,
    dynamic requestBody,
    dynamic responseBody,
    dynamic data,
    dynamic error,
    StackTrace? stackTrace,
    Duration? duration,
    String? box,
    String? key,
  }) {
    if (!kDebugMode) return;

    final LogEntry entry = LogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      message: message,
      timestamp: DateTime.now(),
      url: url,
      method: method,
      statusCode: statusCode,
      requestBody: requestBody != null ? _safeJsonEncode(requestBody) : null,
      responseBody: responseBody != null ? _truncateJson(responseBody) : null,
      data: data != null ? _safeJsonEncode(data) : null,
      error: error?.toString(),
      stackTrace: stackTrace?.toString(),
      duration: duration,
      hiveBox: box,
      hiveKey: key,
    );

    _logs.insert(0, entry);
    if (_logs.length > 500) {
      _logs.removeLast();
    }
    _controller.add(_logs);

    debugPrint('[${type.name.toUpperCase()}] ${entry.timestamp.toIso8601String()} — $message');
    if (url != null) debugPrint('  URL: $url');
    if (statusCode != null) debugPrint('  Status: $statusCode');
    if (error != null) debugPrint('  Error: $error');
  }

  static String _safeJsonEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }

  static String _truncateJson(dynamic data) {
    try {
      final String encoded = jsonEncode(data);
      if (encoded.length > 2000) {
        return '${encoded.substring(0, 2000)}... [TRUNCATED]';
      }
      return encoded;
    } catch (_) {
      final String str = data.toString();
      if (str.length > 2000) {
        return '${str.substring(0, 2000)}... [TRUNCATED]';
      }
      return str;
    }
  }

  static void clear() {
    _logs.clear();
    _controller.add(_logs);
  }
}
