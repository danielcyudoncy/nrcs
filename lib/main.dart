// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/env.dart';
import 'features/rundown/views/rundown_page.dart';
import 'features/auth/login_page.dart';
import 'features/landing/splash_page.dart';
import 'features/landing/landing_page.dart';
import 'features/auth/create_account_page.dart';
import 'core/services/story_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  runApp(const NRCSApp());
}

class NRCSApp extends StatelessWidget {
  const NRCSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // register shared services
    Get.put(StoryService(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'NRCS',
          theme: AppTheme.lightTheme,
          initialRoute: '/splash',
          getPages: [
            GetPage(name: '/', page: () => const RundownPage()),
            GetPage(name: '/login', page: () => const LoginPage()),
            GetPage(name: '/splash', page: () => const SplashPage()),
            GetPage(name: '/landing', page: () => const LandingPage()),
            GetPage(name: '/create-account', page: () => const CreateAccountPage()),
          ],
        );
      },
    );
  }
}
