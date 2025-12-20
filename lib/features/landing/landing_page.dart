// features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_utils.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, deviceType) {
            final bool isMobile = deviceType == DeviceType.mobile;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: isMobile
                        ? _buildMobileLayout(context)
                        : _buildDesktopLayout(context),
                  ),
                ),
                Container(
                  color: AppColors.glassWhite10,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Built for speed • Realtime • Collaborative',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTitle(),
        const SizedBox(height: 40),
        _buildFeatureCard(context),
        const SizedBox(height: 40),
        _buildAuthButtons(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 30),
              _buildAuthButtons(),
            ],
          ),
        ),
        Expanded(child: Center(child: _buildFeatureCard(context))),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text('NRCS', style: AppTheme.headingLarge),
        const SizedBox(height: 16),
        Text(
          'A modern control room for live news rundowns.',
          textAlign: TextAlign.center,
          style: AppTheme.headingSmall,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context) {
    return Card(
      color: AppColors.backgroundCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 420,
        height: 340,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timeline, size: 80, color: AppColors.glassWhite),
            const SizedBox(height: 20),
            Text(
              'Rundown editor, real-time updates and granular permissions.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () => Get.toNamed('/login'),
            child: Text('Log in', style: AppTheme.button),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () => Get.toNamed('/create-account'),
            child: Text('Sign up', style: AppTheme.button),
          ),
        ),
      ],
    );
  }
}
