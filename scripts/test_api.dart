import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final url = Uri.parse('https://raw.githubusercontent.com/thiagobodruk/bible/master/json/ar_svd.json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    print('Books count: ${data.length}');
    print('Book 1: ${jsonEncode(data.first).substring(0, 300)}');
  }
}
