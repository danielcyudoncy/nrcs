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
      body: Stack(
        children: [
          // full-screen subtle hero gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF0B2545)],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ResponsiveBuilder(
                              builder: (context, deviceType) {
                                final bool isMobile =
                                    deviceType == DeviceType.mobile;
                                return isMobile
                                    ? _buildMobileLayout(context, constraints)
                                    : _buildDesktopLayout(context, constraints);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Footer placed outside constrained center so it spans full width
                    _buildFooter(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, BoxConstraints constraints) {
    final double gap = 28;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          _buildTitle(),
          SizedBox(height: gap),
          _buildFeatureCard(context, constraints),
          SizedBox(height: gap),
          _buildAuthButtons(isVertical: true),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 30),
              SizedBox(height: 8),
              _buildAuthButtons(isVertical: false),
            ],
          ),
        ),
        Expanded(child: Center(child: _buildFeatureCard(context, constraints))),
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
          style: AppTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, BoxConstraints constraints) {
    final double maxWidth = constraints.maxWidth;
    final double cardWidth = maxWidth < 480 ? maxWidth * 0.9 : 420;
    final double cardHeight = maxWidth < 420 ? maxWidth * 0.75 : 340;

    return Card(
      color: AppColors.backgroundCard,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timeline, size: 72, color: AppColors.glassWhite),
              const SizedBox(height: 18),
              Text(
                'Rundown editor, real-time updates and granular permissions.',
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtons({bool isVertical = false}) {
    final login = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
      ),
      onPressed: () => Get.toNamed('/login'),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Log in',
          style: AppTheme.button,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final signup = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
      ),
      onPressed: () => Get.toNamed('/create-account'),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Sign up',
          style: AppTheme.button,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );

    if (isVertical) {
      return Column(children: [login, const SizedBox(height: 12), signup]);
    }

    return Row(
      children: [
        Expanded(child: login),
        const SizedBox(width: 16),
        Expanded(child: signup),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: AppColors.glassWhite10,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Built for speed • Realtime • Collaborative',
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
