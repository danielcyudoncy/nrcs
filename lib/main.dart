// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'core/env.dart';
import 'features/rundown/views/rundown_page.dart';
import 'features/rundown/views/story_create_page.dart';
import 'features/auth/login_page.dart';
import 'features/landing/splash_page.dart';
import 'features/landing/landing_page.dart';
import 'features/auth/create_account_page.dart';
import 'features/dashboard/user_dashboard.dart';
import 'features/profile/views/profile_page.dart';
import 'core/services/story_service.dart';
import 'core/auth/auth_controller.dart';
import 'core/utils/responsive_utils.dart';
import 'core/utils/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NRCSApp());
}

class NRCSApp extends StatefulWidget {
  const NRCSApp({super.key});

  @override
  State<NRCSApp> createState() => _NRCSAppState();
}

class _NRCSAppState extends State<NRCSApp> {
  @override
  void initState() {
    super.initState();
    // register shared services
    Get.put(StoryService(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(ResponsiveController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile design size
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<ThemeController>(
          builder: (themeCtrl) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NRCS',
            theme: themeCtrl.currentTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            initialRoute: '/splash',
            getPages: [
              GetPage(name: '/', page: () => const RundownPage()),
              GetPage(name: '/login', page: () => const LoginPage()),
              GetPage(name: '/splash', page: () => const SplashPage()),
              GetPage(name: '/landing', page: () => const LandingPage()),
              GetPage(name: '/dashboard', page: () => const UserDashboard()),
              GetPage(name: '/rundown', page: () => const RundownPage()),
              GetPage(
                name: '/create-story',
                page: () => const StoryCreatePage(),
              ),
              GetPage(
                name: '/create-account',
                page: () => const CreateAccountPage(),
              ),
              GetPage(name: '/profile', page: () => const ProfilePage()),
            ],
          ),
        );
      },
    );
  }
}
