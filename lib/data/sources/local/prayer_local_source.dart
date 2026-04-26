import 'package:shared_preferences/shared_preferences.dart';

class PrayerLocalSource {
  PrayerLocalSource(this.preferences);
  final SharedPreferences preferences;

  Future<void> cachePrayer(String key, String value) async {
    await preferences.setString(key, value);
  }

  String? getPrayer(String key) => preferences.getString(key);

  Set<String> getKeys() => preferences.getKeys();

  Future<void> remove(String key) => preferences.remove(key);
}
