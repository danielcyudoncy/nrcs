// features/auth/login_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/validations.dart';
import '../../core/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _obscureText = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authController.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
        Get.offNamed('/rundown');
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

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
                            _buildIllustrationSection(isMobile),
                            const SizedBox(height: 24),
                            _buildLoginCard(context, isMobile),
                          ],
                        )
                      : Row(
                          // Desktop: side by side
                          children: [
                            Expanded(child: _buildLoginCard(context, isMobile)),
                            const SizedBox(width: 40),
                            Expanded(
                              child: _buildIllustrationSection(isMobile),
                            ),
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
  Widget _buildLoginCard(BuildContext context, bool isMobile) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: AppTheme.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 20.sp : 6.sp,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: AppTextTheme.label.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 12.sp : 14,
                        ),
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 14,
                          horizontal: 12,
                        ),
                        isDense: !isMobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorStyle: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      validator: Validators.validatePassword,
                      obscureText: _obscureText,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: AppTextTheme.label.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 12.sp : 14,
                        ),
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 14,
                          horizontal: 12,
                        ),
                        isDense: !isMobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                        errorStyle: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          color: Colors.red,
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
                            fontSize: isMobile ? 12.sp : 14,
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
                        onPressed: _authController.isLoading.value
                            ? null
                            : _login,
                        child: _authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Sign in",
                                style: AppTextTheme.button.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: isMobile ? 16.sp : 14,
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
                              fontSize: isMobile ? 12.sp : 14,
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
                            fontSize: isMobile ? 12.sp : 14,
                          ),
                          children: [
                            TextSpan(
                              text: " Register for free",
                              style: AppTextTheme.bodySmall.copyWith(
                                color: AppColors.textOriginal,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 12.sp : 14,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed('/create-account'),
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
  Widget _buildIllustrationSection(bool isMobile) {
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
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: isMobile ? 14.sp : 14,
          ),
        ),
      ],
    );
  }
}
