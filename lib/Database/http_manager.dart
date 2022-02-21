// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;

class HttpManager {
  Future<String> getNumberPlate(String url) async {
    url = url
        .replaceAll('https', 'secure')
        .replaceAll('/', 'slash')
        .replaceAll('.', 'dot')
        .replaceAll(':', 'colon')
        .replaceAll('-', 'dash')
        .replaceAll('&', 'ampersand')
        .replaceAll('%', 'per')
        .replaceAll('?', 'ques');

    String baseUrl = 'http://192.168.1.3:5000/number-plate/';
    print("URL is ${baseUrl + url}");
    http.Response res = await http.get(Uri.parse(baseUrl + url));
    return res.body;
  }
}
