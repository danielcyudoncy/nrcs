// features/auth/create_account_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/network/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../../core/validations.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();
  bool _loading = false;
  bool _agreeToTerms = false;
  bool _obscureText = true;
  bool _confirmObscureText = true;

  void _create() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        // Show snackbar or dialog to agree to terms
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
          ),
        );
        return;
      }

      setState(() => _loading = true);
      await ApiClient().post('/create', {
        'username': _user.text,
        'password': _pass.text,
      });
      setState(() => _loading = false);
      Get.offNamed('/rundown');
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
                    color: Colors.black.withAlpha((0.25 * 255).round()),
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
                            _buildCreateAccountCard(context, isMobile),
                          ],
                        )
                      : Row(
                          // Desktop: side by side
                          children: [
                            Expanded(
                              child: _buildCreateAccountCard(context, isMobile),
                            ),
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

  Widget _buildCreateAccountCard(BuildContext context, bool isMobile) {
    return SizedBox(
      height: isMobile ? 500 : 400, // Match illustration section height
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create Account", style: AppTheme.headingSmall),
                    const SizedBox(height: 12),

                    // Name field
                    TextFormField(
                      controller: _name,
                      validator: Validators.validateName,
                      style: AppTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: AppTheme.label,
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 8,
                          horizontal: 12,
                        ),
                        isDense: !isMobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _user,
                      validator: Validators.validateEmail,
                      style: AppTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: AppTheme.label,
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 8,
                          horizontal: 12,
                        ),
                        isDense: !isMobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorStyle: AppTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _pass,
                      validator: Validators.validateStrongPassword,
                      obscureText: _obscureText,
                      style: AppTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: AppTheme.label,
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 8,
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
                        errorStyle: AppTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPass,
                      validator: (value) =>
                          Validators.validateConfirmPassword(value, _pass.text),
                      obscureText: _confirmObscureText,
                      style: AppTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: AppTheme.label,
                        filled: true,
                        fillColor: AppColors.glassWhite10,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 16 : 8,
                          horizontal: 12,
                        ),
                        isDense: !isMobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                            () => _confirmObscureText = !_confirmObscureText,
                          ),
                        ),
                        errorStyle: AppTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (v) =>
                              setState(() => _agreeToTerms = v ?? false),
                          activeColor: AppColors.buttonPrimary,
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the Terms and Conditions",
                            style: AppTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),

                    // Create account button
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
                        onPressed: _loading ? null : _create,
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('CREATE ACCOUNT', style: AppTheme.button),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sign in link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: AppTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: "  Sign In",
                              style: AppTheme.bodySmall?.copyWith(
                                color: AppColors.textOriginal,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.offNamed('/login'),
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
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }
}
