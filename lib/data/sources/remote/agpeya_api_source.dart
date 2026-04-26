import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/network/api_service.dart';
import 'package:html/parser.dart' as html_parser;

class AgpeyaApiSource {
  AgpeyaApiSource(this.apiService);
  final AgpeyaApiService apiService;

  Future<String> getPrayerContent(int hour) async {
    final response = await apiService.getPrayerHourHtml(hour.toString());
    final document = html_parser.parse(response.data ?? '');
    final String raw = document.body?.text.trim() ?? '';
    final String text = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty || text.length < 80) {
      return fallbackPrayerArabicByHour[hour] ??
          (hour == 1 ? firstHourFallbackArabic : 'صلاة الأجبية غير متاحة حاليا.');
    }
    return text;
  }
}
