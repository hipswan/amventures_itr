import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class NetworkHelper {
  static Future<http.Response> get(
      {String? apiUrl,
      Map<String, dynamic>? params,
      int timeout = 60000}) async {
    var response = await http.get(Uri.parse(apiUrl!)).timeout(
          Duration(milliseconds: timeout),
        );

    return response;
  }

  static Future<http.Response> post(
      {String? apiUrl, Map<String, dynamic>? body, int timeout = 60000}) async {
    var response = await http.post(Uri.parse(apiUrl!)).timeout(
          Duration(milliseconds: timeout),
        );
    return response;
  }
}
