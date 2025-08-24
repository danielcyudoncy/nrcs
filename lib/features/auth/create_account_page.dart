// features/auth/create_account_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/network/api_client.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  void _create() async {
    setState(() => _loading = true);
    await ApiClient().post('/create', {'username': _user.text, 'password': _pass.text});
    setState(() => _loading = false);
    Get.offNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final leftPanel = Container(
      height: isWide ? double.infinity : 220,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF0066CC)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Create Account', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Join NRCS and collaborate on rundowns', style: TextStyle(color: Colors.white70)),
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
          Text('Create account', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(controller: _user, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 12),
          TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _loading ? null : _create, child: _loading ? const CircularProgressIndicator() : const Text('Create account')),
          const SizedBox(height: 12),
          Center(child: TextButton(onPressed: () => Get.offNamed('/login'), child: const Text('Back to Login')))
        ]),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isWide
            ? Row(children: [Expanded(child: leftPanel), Expanded(child: Center(child: form))])
            : SingleChildScrollView(child: Column(children: [leftPanel, const SizedBox(height: 12), Padding(padding: const EdgeInsets.all(12), child: form)])),
      ),
    );
  }
}
