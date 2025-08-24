// core/network/api_client.dart
import 'dart:async';

class ApiClient {
  // mock client - in future generated from OpenAPI
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    await Future.delayed(Duration(milliseconds: 300));
    if (path == '/login') {
      // accept any creds and return a token
      return {'token': 'mock-token-${DateTime.now().millisecondsSinceEpoch}'};
    }
    return {};
  }
}
