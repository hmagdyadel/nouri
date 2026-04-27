import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final dir = Directory('assets/bible');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  print('Downloading Arabic Bible...');
  final arRes = await http.get(Uri.parse('https://raw.githubusercontent.com/thiagobodruk/bible/master/json/ar_svd.json'));
  if (arRes.statusCode == 200) {
    await File('assets/bible/bible_ar.json').writeAsString(arRes.body);
    print('Arabic Bible saved.');
  }

  print('Downloading English Bible...');
  final enRes = await http.get(Uri.parse('https://raw.githubusercontent.com/thiagobodruk/bible/master/json/en_kjv.json'));
  if (enRes.statusCode == 200) {
    await File('assets/bible/bible_en.json').writeAsString(enRes.body);
    print('English Bible saved.');
  }
}
