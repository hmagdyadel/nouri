import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/network/api_service.dart';
import 'package:html/parser.dart' as html_parser;

class AgpeyaApiSource {
  AgpeyaApiSource(this.apiService);
  final AgpeyaApiService apiService;

  Future<String> getPrayerContent(int hour) async {
    final response = await apiService.getPrayerHourHtml(hour.toString());
    final document = html_parser.parse(response.data ?? '');
    final String text = document.body?.text.trim() ?? '';
    if (text.isEmpty && hour == 1) {
      return firstHourFallbackArabic;
    }
    return text;
  }
}
