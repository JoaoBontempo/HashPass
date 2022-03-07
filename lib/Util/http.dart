import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

const BASE_URL = "https://hashpass-api.herokuapp.com";
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
