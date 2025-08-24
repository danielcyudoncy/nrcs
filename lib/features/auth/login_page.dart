// features/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/auth/auth_service.dart';
import 'package:nrcs/core/network/api_client.dart';
import 'package:nrcs/core/auth/token_provider.dart';
import 'package:nrcs/core/network/http_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _loading = false.obs;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthService(ApiClient());
  }

  void _doLogin() async {
    _loading.value = true;
    final token = await _auth.login(_user.text, _pass.text);
    TokenProvider.token = token;
  TokenProvider.username = _user.text;
  TokenProvider.roles = _user.text == 'approver' ? ['approver'] : [];
    HttpClient.setToken(token);
    _loading.value = false;
    // pop to app
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => Get.offNamed('/landing'), child: const Text('Back to landing'))),
            TextField(controller: _user, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 8),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(onPressed: _loading.value ? null : _doLogin, child: _loading.value ? const CircularProgressIndicator() : const Text('Login'))),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Get.toNamed('/create-account'), child: const Text('Create an account'))
          ],
        ),
      ),
    );
  }
}
