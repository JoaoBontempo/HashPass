import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

const HEADERS = {"content-type": "application/json; charset=utf-8"};

class HTTPRequest {
  static Future<String> requestPasswordLeak(String hash) async {
    if (await checkUserConnection()) {
      http.Response response = await http.get(
        Uri.parse(
            'https://api.pwnedpasswords.com/range/${hash.substring(0, 5)}'),
      );
      return utf8.decode(response.bodyBytes);
    } else {
      return "";
    }
  }

  static Future<String> getRequest(String route) async {
    http.Response response = await http.get(
      Uri.parse(route),
      headers: HEADERS,
    );
    return utf8.decode(response.bodyBytes);
  }

  static Future<String> postRequest(String route, String json) async {
    http.Response response = await http.post(
      Uri.parse(route),
      body: json,
      headers: HEADERS,
    );
    return utf8.decode(response.bodyBytes);
  }

  static Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
