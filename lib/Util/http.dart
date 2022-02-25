import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

const BASE_URL = "http://634c-187-120-135-190.ngrok.io";
const HEADERS = {"content-type": "application/json; charset=utf-8"};

class HTTPRequest {
  static Future<String> postRequest(String route, String json) async {
    http.Response response = await http.post(
      Uri.parse(BASE_URL + route),
      body: json,
      headers: HEADERS,
    );
    return utf8.decode(response.bodyBytes);
  }
}
