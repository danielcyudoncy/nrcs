// core/auth/auth_service.dart
import 'dart:async';
import 'package:nrcs/core/network/api_client.dart';
import 'package:nrcs/core/auth/token_provider.dart';

class AuthService {
  final ApiClient api;
  AuthService(this.api);

  Future<User> login(String username, String password) async {
    // Mock authentication with role-based demo users
    final user = _getDemoUser(username, password);
    if (user != null) {
      TokenProvider.setUser(
        'mock-token-${user.username}',
        user.username,
        user.roles,
      );
      return user;
    }

    // Real API call (for future implementation)
    // final resp = await api.post('/login', {'username': username, 'password': password});
    // final token = resp['token'] as String? ?? 'mock-token';
    // final roles = resp['roles'] as List<String>? ?? ['writer'];
    // final user = User(username: username, roles: roles);
    // TokenProvider.setUser(token, username, roles);
    // return user;

    throw Exception('Invalid credentials');
  }

  User? _getDemoUser(String username, String password) {
    // Demo users for testing
    if (username == 'writer' && password == 'password') {
      return User(username: 'writer', roles: ['writer']);
    }
    if (username == 'caster' && password == 'password') {
      return User(username: 'caster', roles: ['caster']);
    }
    if (username == 'admin' && password == 'password') {
      return User(username: 'admin', roles: ['admin', 'writer', 'caster']);
    }
    return null;
  }

  void logout() {
    TokenProvider.clear();
  }
}
