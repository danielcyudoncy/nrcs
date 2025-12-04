// features/auth/login_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue, // Primary background
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth <= 600;

          return Center(
            child: Container(
              // OUTER CONTAINER (main card frame)
              margin: EdgeInsets.all(isMobile ? 16 : 32),
              padding: EdgeInsets.all(isMobile ? 12 : 20),
              decoration: BoxDecoration(
                color: AppColors.glassWhite10,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                // INNER CONTAINER (glassmorphism for login + logo)
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                constraints: BoxConstraints(
                  maxWidth: 1200,
                  maxHeight: constraints.maxHeight - (isMobile ? 100 : 150),
                ),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite08,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassWhite20),
                ),
                child: SingleChildScrollView(
                  child: isMobile
                      ? Column(
                          // Mobile: illustration on top, login below
                          children: [
                            _buildIllustrationSection(),
                            const SizedBox(height: 24),
                            _buildLoginCard(context),
                          ],
                        )
                      : Row(
                          // Desktop: side by side
                          children: [
                            Expanded(child: _buildLoginCard(context)),
                            const SizedBox(width: 40),
                            Expanded(child: _buildIllustrationSection()),
                          ],
                        ),
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
    return SizedBox(
      height: 500, // Match illustration section height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.glassWhite15,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassWhite30),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: AppTheme.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Email field
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: AppTextTheme.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.glassWhite10,
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
                      labelStyle: AppTextTheme.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.glassWhite10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(
                        Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: AppTextTheme.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Hook with GetX controller
                      },
                      child: Text(
                        "Sign in",
                        style: AppTextTheme.button.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.glassWhite30)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          "Or Continue With",
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.glassWhite30)),
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
                        style: AppTextTheme.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: "Register for free",
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppColors.textPrimary,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/login_icon.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Built for speed . Realtime . Collaborative",
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
