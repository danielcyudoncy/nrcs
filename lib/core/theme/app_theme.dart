// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Channels App Theme Colors
/// Based on the Channels branding with blue and red color scheme
class AppColors {
  // Primary Brand Colors
  static const Color primaryBlue = Color(0xFF1E2A5C);
  static const Color accentRed = Color(0xFFE53E3E);
  static const Color orangeAccent = Color(0xFFFF6B35);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color backgroundCard = Color(0xFF1A1F2E);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textAccent = Color(0xFFFF6B35);

  // Glassmorphism Colors
  static const Color glassWhite = Colors.white;
  static const Color glassBlue = Color(0xFF1E2A5C);

  // Opacity variants for glassmorphism effects
  static Color glassWhite10 = Colors.white.withOpacity(0.1);
  static Color glassWhite08 = Colors.white.withOpacity(0.08);
  static Color glassWhite15 = Colors.white.withOpacity(0.15);
  static Color glassWhite20 = Colors.white.withOpacity(0.2);
  static Color glassWhite30 = Colors.white.withOpacity(0.3);
  static Color glassWhite70 = Colors.white.withOpacity(0.7);

  // Button Colors
  static const Color buttonPrimary = primaryBlue;
  static const Color buttonSecondary = accentRed;

  // Status Colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53E3E);
}

/// Channels App Text Theme
class AppTextTheme {
  static TextStyle get headingLarge => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'raleway',
  );

  static TextStyle get headingMedium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'raleway',
  );

  static TextStyle get headingSmall => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'raleway',
  );

  static TextStyle get bodyLarge => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'raleway',
  );

  static TextStyle get bodyMedium => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'raleway',
  );

  static TextStyle get bodySmall => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'raleway',
  );

  static TextStyle get label => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'raleway',
  );

  static TextStyle get button => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'raleway',
  );
}

/// Channels App Theme Data
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: MaterialColor(
      AppColors.primaryBlue.value,
      <int, Color>{
        50: AppColors.primaryBlue.withValues(alpha: 0.1),
        100: AppColors.primaryBlue.withValues(alpha: 0.2),
        200: AppColors.primaryBlue.withOpacity(0.3),
        300: AppColors.primaryBlue.withOpacity(0.4),
        400: AppColors.primaryBlue.withOpacity(0.5),
        500: AppColors.primaryBlue.withOpacity(0.6),
        600: AppColors.primaryBlue.withOpacity(0.7),
        700: AppColors.primaryBlue.withOpacity(0.8),
        800: AppColors.primaryBlue.withOpacity(0.9),
        900: AppColors.primaryBlue,
      },
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      displaySmall: headingSmall,
      headlineMedium: headingMedium,
      headlineSmall: headingSmall,
      titleLarge: headingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      titleMedium: bodyMedium,
      titleSmall: bodySmall,
      bodySmall: bodySmall,
      labelLarge: button,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextTheme.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite10,
      labelStyle: AppTextTheme.label.copyWith(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.glassWhite20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.glassWhite20),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.accentRed),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 0,
    ),
  );

  // Import text styles for direct access
  static TextStyle get headingLarge => AppTextTheme.headingLarge;
  static TextStyle get headingMedium => AppTextTheme.headingMedium;
  static TextStyle get headingSmall => AppTextTheme.headingSmall;
  static TextStyle get bodyLarge => AppTextTheme.bodyLarge;
  static TextStyle get bodyMedium => AppTextTheme.bodyMedium;
  static TextStyle get bodySmall => AppTextTheme.bodySmall;
  static TextStyle get label => AppTextTheme.label;
  static TextStyle get button => AppTextTheme.button;
}