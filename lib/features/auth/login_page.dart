// features/auth/login_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A5C), // Primary background
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          bool isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 900;
          bool isMobile = constraints.maxWidth <= 600;

          return Center(
            child: Container(
              // OUTER CONTAINER (main card frame)
              margin: EdgeInsets.all(isMobile ? 16 : 32),
              padding: EdgeInsets.all(isMobile ? 12 : 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                // INNER CONTAINER (glassmorphism for login + logo)
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                constraints: const BoxConstraints(maxWidth: 1200),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: isDesktop || isTablet
                    ? Row(
                        children: [
                          Expanded(child: _buildLoginCard(context)),
                          const SizedBox(width: 40),
                          Expanded(child: _buildIllustrationSection()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildLoginCard(context),
                          const SizedBox(height: 24),
                          _buildIllustrationSection(),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// LOGIN CARD
  Widget _buildLoginCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Email field
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(
                    Icons.visibility_off,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B4C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Hook with GetX controller
                  },
                  child: const Text("Sign in"),
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.white38)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Or Continue With",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white38)),
                ],
              ),
              const SizedBox(height: 16),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(Icons.g_mobiledata, Colors.red, () {}),
                  const SizedBox(width: 12),
                  _socialButton(Icons.apple, Colors.black, () {}),
                  const SizedBox(width: 12),
                  _socialButton(Icons.facebook, Colors.blue, () {}),
                ],
              ),
              const SizedBox(height: 16),

              // Register link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account yet? ",
                    style: const TextStyle(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Register for free",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SOCIAL LOGIN BUTTON
  static Widget _socialButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  /// ILLUSTRATION SECTION
  Widget _buildIllustrationSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.bubble_chart, size: 150, color: Colors.white),
          SizedBox(height: 24),
          Text(
            "Built for speed . Realtime . Collaborative",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
