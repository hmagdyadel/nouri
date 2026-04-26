import 'package:agpeya/core/storage/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait(<Future<void>>[
      Hive.openBox<dynamic>(HiveBoxes.agpeyaHours),
      Hive.openBox<dynamic>(HiveBoxes.bibleChapters),
      Hive.openBox<dynamic>(HiveBoxes.dailyReadings),
      Hive.openBox<dynamic>(HiveBoxes.synaxarium),
      Hive.openBox<dynamic>(HiveBoxes.prayerLogs),
      Hive.openBox<dynamic>(HiveBoxes.userProfile),
      Hive.openBox<dynamic>(HiveBoxes.appSettings),
    ]);
  }
}
