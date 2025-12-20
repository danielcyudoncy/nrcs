// features/landing/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/auth/token_provider.dart';
import '../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (TokenProvider.token == null) {
        Get.offNamed('/landing');
      } else {
        // Redirect based on user role
        if (TokenProvider.isCaster) {
          Get.offNamed('/rundown');
        } else {
          Get.offNamed('/dashboard');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundDark, AppColors.primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_tethering,
                size: 96,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text('NRCS', style: AppTheme.headingMedium),
              const SizedBox(height: 8),
              Text('News Rundown Control System', style: AppTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
