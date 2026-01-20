import 'package:http/http.dart' as http;
import '../objects/path.dart';
import 'dart:convert';

class API {
  static const String _url = 'https://kahoot-api.mercantec.tech/api/';

  // Post Request
  static Future<http.Response> postRequest(ApiPath action, Map<String, dynamic> envelope) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'text/plain',
    };

    // Post the request
    final temp = http.post(
      Uri.parse((_url) + action.value),
      headers: header,
      body: json.encode(envelope),
    );
    return temp;
  }

  // Get Request
  static Future<http.Response> getRequest(ApiPath action) async {
    // Create header with action
    final header = {
      'Accept': 'application/json',
    };

    try {
      // Get Request
      var temp = http.get(
        Uri.parse((_url) + action.value),
        headers: header,
      );
      return temp;
    } catch (_) {
      return http.Response('{"status":"error","message":"Could not connect to server."}', 400);
    }
  }

  // Get Request
  static Future<http.Response> getRequestWithId(ApiPath action, String id) async {
    // Create header with action
    final header = {
      'Accept': 'application/json',
    };

    try {
      // Get Request
      var temp = http.get(
        Uri.parse('$_url${action.value}/$id'),
        headers: header,
      );
      return temp;
    } catch (_) {
      return http.Response('{"status":"error","message":"Could not connect to server."}', 400);
    }
  }


  // Get Request
  static Future<http.Response> getCurrentQuestion(String id) async {
    // Create header with action
    final header = {
      'Accept': 'application/json',
    };

    try {
      // Get Request
      var temp = http.get(
        Uri.parse('${_url}participant/session/$id/current-question'),
        headers: header,
      );
      return temp;
    } catch (_) {
      return http.Response('{"status":"error","message":"Could not connect to server."}', 400);
    }
  }
}