import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kahoot_kopi/classes/objects/join_session_dto.dart';
import 'dart:convert';

import 'package:kahoot_kopi/classes/objects/path.dart';

class API {
  static const String _url = 'https://kahoot-api.mercantec.tech/api/';

  static Map<String, dynamic> createJoinEnvelope(JoinSessionDto item) {
    var envelope = {
      'sessionPin': item.pin,
      'nickname': item.nickname,
    };
    
    return envelope;
  }

  // Post Request
  static Future<http.Response> postRequest(ApiPath action, Map<String, dynamic> envelope) async {
    if (!kReleaseMode) {
      return http.Response('{"status":"error","message":"API calls are disabled in debug mode."}', 400);
    }

    // Create header with action
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
      var temp = await http.get(
        Uri.parse((_url) + action.value),
        headers: header,
      );
      return temp;
    } catch (e) {
      return http.Response('{"status":"error","message":"Could not connect to server."}', 400);
    }
  }  
}