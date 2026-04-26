import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  LocalNotificationsService(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    tz_data.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _isInitialized = true;
  }

  Future<void> syncPrayerReminders({
    required bool enabled,
    required List<String> hourTimes,
  }) async {
    await _plugin.cancelAll();
    if (!enabled) return;

    for (int i = 0; i < hourTimes.length; i++) {
      final String time = hourTimes[i];
      final List<String> parts = time.split(':');
      final int hour = int.tryParse(parts.first) ?? 8;
      final int minute = int.tryParse(parts.last) ?? 0;
      await _plugin.zonedSchedule(
        i + 100,
        'وقت الصلاة',
        'موعد صلاة الأجبية ($time)',
        _nextInstance(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'agpeya_prayer',
            'Prayer reminders',
            channelDescription: 'Daily Agpeya prayer reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
