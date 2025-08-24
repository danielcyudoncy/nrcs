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
  bool _remember = false;
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
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final leftPanel = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF0066CC)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome Page', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Sign in to your account', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            if (isWide)
              SizedBox(height: 200, child: Image.network('https://i.imgur.com/3GQ8m2D.png', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
          ]),
        ),
      ),
    );

    final form = Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: isWide ? 420 : double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Hello!', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent)),
          const SizedBox(height: 12),
          TextField(controller: _user, decoration: const InputDecoration(labelText: 'Email Address')),
          const SizedBox(height: 12),
          TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
              const Text('Remember')
            ]),
            TextButton(onPressed: () {/* TODO: forgot */}, child: const Text('Forgot Password ?'))
          ]),
          const SizedBox(height: 12),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blueAccent),
                onPressed: _loading.value ? null : _doLogin,
                child: _loading.value ? const CircularProgressIndicator() : const Text('SUBMIT', style: TextStyle(letterSpacing: 1.5)),
              )),
          const SizedBox(height: 12),
          Center(child: TextButton(onPressed: () => Get.toNamed('/create-account'), child: const Text('Create Account')))
        ]),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isWide
            ? Row(children: [Expanded(child: leftPanel), Expanded(child: Center(child: form))])
            : SingleChildScrollView(
                child: Column(children: [leftPanel, const SizedBox(height: 12), Padding(padding: const EdgeInsets.all(12), child: form)]),
              ),
      ),
    );
  }
}
