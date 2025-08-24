// core/auth/auth_service.dart
import 'dart:async';
import 'package:nrcs/core/network/api_client.dart';

class AuthService {
  final ApiClient api;
  AuthService(this.api);

  Future<String> login(String username, String password) async {
    // mock: call api and return token
    final resp = await api.post('/login', {'username': username, 'password': password});
    // api returns {'token':'...'} in this mock
    return resp['token'] as String? ?? 'mock-token';
  }
}
