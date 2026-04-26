import 'package:agpeya/core/constants/prayer_data.dart';
import 'package:agpeya/core/network/agpeya_api_service.dart';
import 'package:agpeya/core/storage/hive_boxes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

class AgpeyaApiSource {
  AgpeyaApiSource(this.apiService);
  final AgpeyaApiService apiService;

  Future<String> getPrayerContent(int hour) async {
    final String slug = _hourSlug(hour);
    final Box<dynamic> box = Hive.box<dynamic>(HiveBoxes.agpeyaHours);
    final String key = 'hour_en_$slug';
    final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
    final bool online = !connectivity.contains(ConnectivityResult.none);

    if (online) {
      try {
        final Map<String, dynamic> response = await apiService.getPrayerHour(slug);
        final String parsed = _parseEnglishResponse(response);
        if (parsed.isNotEmpty) {
          await box.put(key, parsed);
          return parsed;
        }
      } catch (_) {}
    }

    final cached = box.get(key);
    if (cached is String && cached.isNotEmpty) {
      return cached;
    }

    return fallbackPrayerEnglishByHour[hour] ?? 'Prayer not available.';
  }

  String _parseEnglishResponse(Map<String, dynamic> response) {
    final StringBuffer buffer = StringBuffer();
    
    // 1. Introduction & Opening
    if (response['introduction'] != null) {
      buffer.writeln(response['introduction']);
      buffer.writeln();
    }
    
    if (response['opening'] != null && response['opening']['content'] != null) {
      final List<dynamic> content = response['opening']['content'] as List<dynamic>;
      for (final dynamic line in content) {
        buffer.writeln(line.toString());
      }
      buffer.writeln();
    }

    // 2. Thanksgiving
    if (response['thanksgiving'] != null) {
      final Map<String, dynamic> tg = response['thanksgiving'] as Map<String, dynamic>;
      buffer.writeln('### ${tg['title']}');
      final List<dynamic>? content = tg['content'] as List<dynamic>?;
      if (content != null) {
        for (final dynamic line in content) {
          buffer.writeln(line.toString());
        }
      }
      buffer.writeln();
    }

    // 3. Introductory Psalm (Psalm 50)
    if (response['introductoryPsalm'] != null) {
      final Map<String, dynamic> ps50 = response['introductoryPsalm'] as Map<String, dynamic>;
      buffer.writeln('### ${ps50['title']} (${ps50['reference']})');
      final List<dynamic>? verses = ps50['verses'] as List<dynamic>?;
      if (verses != null) {
        for (final dynamic v in verses) {
          if (v is Map<String, dynamic>) {
            buffer.writeln(v['text']);
          }
        }
      }
      buffer.writeln();
    }

    // 4. Psalms
    final List<dynamic>? psalms = response['psalms'] as List<dynamic>?;
    if (psalms != null) {
      if (response['psalmsIntro'] != null) {
        buffer.writeln(response['psalmsIntro']);
        buffer.writeln();
      }
      for (final dynamic p in psalms) {
        if (p is Map<String, dynamic>) {
          buffer.writeln('### ${p['title']} (${p['reference']})');
          final List<dynamic>? verses = p['verses'] as List<dynamic>?;
          if (verses != null) {
            for (final dynamic v in verses) {
              if (v is Map<String, dynamic>) {
                buffer.writeln(v['text']);
              }
            }
          }
          buffer.writeln();
        }
      }
    }
    
    // 5. Gospel
    final Map<String, dynamic>? gospel = response['gospel'] as Map<String, dynamic>?;
    if (gospel != null) {
      buffer.writeln('### Gospel (${gospel['reference']})');
      if (gospel['rubric'] != null) buffer.writeln('*${gospel['rubric']}*');
      final List<dynamic>? verses = gospel['verses'] as List<dynamic>?;
      if (verses != null) {
        for (final dynamic v in verses) {
          if (v is Map<String, dynamic>) {
            buffer.writeln(v['text']);
          }
        }
      }
      buffer.writeln();
    }
    
    // 6. Litanies
    final Map<String, dynamic>? litanies = response['litanies'] as Map<String, dynamic>?;
    if (litanies != null) {
      buffer.writeln('### ${litanies['title']}');
      final List<dynamic>? content = litanies['content'] as List<dynamic>?;
      if (content != null) {
        for (final dynamic c in content) {
          buffer.writeln(c.toString());
        }
      }
      buffer.writeln();
    }
    
    // 7. Lord's Prayer
    final Map<String, dynamic>? lordsPrayer = response['lordsPrayer'] as Map<String, dynamic>?;
    if (lordsPrayer != null) {
      buffer.writeln('### ${lordsPrayer['title']}');
      final List<dynamic>? content = lordsPrayer['content'] as List<dynamic>?;
      if (content != null) {
        for (final dynamic c in content) {
          buffer.writeln(c.toString());
        }
      }
      buffer.writeln();
    }
    
    // 8. Closing
    final Map<String, dynamic>? closing = response['closing'] as Map<String, dynamic>?;
    if (closing != null) {
      buffer.writeln('### ${closing['title']}');
      final List<dynamic>? content = closing['content'] as List<dynamic>?;
      if (content != null) {
        for (final dynamic c in content) {
          buffer.writeln(c.toString());
        }
      }
      buffer.writeln();
    }
    
    return buffer.toString().trim();
  }

  String _hourSlug(int hour) {
    switch (hour) {
      case 1: return 'prime';
      case 3: return 'terce';
      case 6: return 'sext';
      case 9: return 'none';
      case 11: return 'vespers';
      case 12: return 'compline';
      case 0: return 'midnight';
      default: return 'prime';
    }
  }
}
