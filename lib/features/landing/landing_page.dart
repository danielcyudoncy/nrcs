// features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(children: [
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,  children: [
                      Text('NRCS', style: AppTheme.headingSmall.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('A modern control room for live news rundowns.', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                      Row(children: [
                        Expanded(flex: 3,
                          child: ElevatedButton(onPressed: () => Get.toNamed('/login'), child: const Text('Log in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
                        const SizedBox(width: 12),
                        ElevatedButton(onPressed: () => Get.toNamed('/create-account'), child: const Text('Create account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                      ])
                    ]),
                  ),
                  Expanded(
                    child: Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          width: 420,
                          height: 340,
                          padding: const EdgeInsets.all(18),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Icon(Icons.timeline, size: 56, color: AppColors.glassWhite),
                            const SizedBox(height: 12),
                            Text('Rundown editor, real-time updates and granular permissions.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              color: AppColors.glassWhite10,
              padding: const EdgeInsets.all(18),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text('Built for speed • Realtime • Collaborative', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'raleway', fontSize: 16))]),
            )
          ],
        ),
      ),
    );
  }
}
