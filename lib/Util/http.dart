import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

const BASE_URL = "https://hashpass-api.herokuapp.com";
const HEADERS = {"content-type": "application/json; charset=utf-8"};

class HTTPRequest {
  static Future<String> requestPasswordLeak(String hash) async {
    if (await _checkUserConnection()) {
      http.Response response = await http.get(
        Uri.parse('https://api.pwnedpasswords.com/range/' + hash.substring(0, 5)),
      );
      return utf8.decode(response.bodyBytes);
    } else {
      return "";
    }
  }

  static Future<String> postRequest(String route, String json) async {
    http.Response response = await http.post(
      Uri.parse(BASE_URL + route),
      body: json,
      headers: HEADERS,
    );
    return utf8.decode(response.bodyBytes);
  }

  static Future<bool> _checkUserConnection() async {
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
