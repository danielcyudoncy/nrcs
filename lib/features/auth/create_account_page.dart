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
  final _name = TextEditingController();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();
  bool _loading = false;
  bool _agreeToTerms = false;

  void _create() async {
    if (!_agreeToTerms) {
      // Show snackbar or dialog to agree to terms
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }
    
    setState(() => _loading = true);
    await ApiClient().post('/create', {'username': _user.text, 'password': _pass.text});
    setState(() => _loading = false);
    Get.offNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF1E3C72),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildCreateAccountForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login_icon.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Join us today',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            
            // Name field
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Email field
            TextFormField(
              controller: _user,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4A90E2)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Password field
            TextFormField(
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4A90E2)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Confirm Password field
            TextFormField(
              controller: _confirmPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4A90E2)),
              ),
            ),
            const SizedBox(height: 15),
            
            // Terms and conditions
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                  activeColor: const Color(0xFF4A90E2),
                ),
                const Text('I agree to the '),
                TextButton(
                  onPressed: () {/* TODO: show terms */},
                  child: const Text(
                    'Terms and Conditions',
                    style: TextStyle(color: Color(0xFF4A90E2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Create account button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              onPressed: _loading ? null : _create,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
            const SizedBox(height: 25),
            
            // Sign in link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () => Get.offNamed('/login'),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}