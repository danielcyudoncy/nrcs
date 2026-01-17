// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nrcs/core/utils/responsive_utils.dart';

/// Channels App Theme Colors
/// Based on the Channels branding with blue and red color scheme
class AppColors {
  // Primary Brand Colors
  static const Color primaryBlue = Color(0xFF022d62);
  static const Color accentRed = Color(0xFFE53E3E);
  static const Color orangeAccent = Color(0xFFFF6B35);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color backgroundCard = Color(0xFF1A1F2E);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textAccent = Color(0xFFFF6B35);
  static const Color textOriginal = Color(0xFF022d62);

  // Glassmorphism Colors
  static const Color glassWhite = Colors.white;
  static const Color glassBlue = Color(0xFF253ebc);

  // Opacity variants for glassmorphism effects
  static Color glassWhite10 = Colors.white.withValues(alpha: 0.1);
  static Color glassWhite08 = Colors.white.withValues(alpha: 0.08);
  static Color glassWhite15 = Colors.white.withValues(alpha: 0.15);
  static Color glassWhite20 = Colors.white.withValues(alpha: 0.2);
  static Color glassWhite30 = Colors.white.withValues(alpha: 0.3);
  static Color glassWhite70 = Colors.white.withValues(alpha: 0.7);

  // Button Colors
  static const Color buttonPrimary = primaryBlue;
  static const Color buttonSecondary = accentRed;

  // Status Colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFb61f24);
}

/// Channels App Theme Data
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: MaterialColor(AppColors.primaryBlue.toARGB32(), <int, Color>{
      50: AppColors.primaryBlue.withValues(alpha: 0.1),
      100: AppColors.primaryBlue.withValues(alpha: 0.2),
      200: AppColors.primaryBlue.withValues(alpha: 0.3),
      300: AppColors.primaryBlue.withValues(alpha: 0.4),
      400: AppColors.primaryBlue.withValues(alpha: 0.5),
      500: AppColors.primaryBlue.withValues(alpha: 0.6),
      600: AppColors.primaryBlue.withValues(alpha: 0.7),
      700: AppColors.primaryBlue.withValues(alpha: 0.8),
      800: AppColors.primaryBlue.withValues(alpha: 0.9),
      900: AppColors.primaryBlue,
    }),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: ResponsiveTextTheme.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
      fontFamily: 'raleway',
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textPrimary,
        textStyle: ResponsiveTextTheme.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite10,
      labelStyle: ResponsiveTextTheme.textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
      ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 0,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(AppColors.primaryBlue.toARGB32(), <int, Color>{
      50: AppColors.primaryBlue.withValues(alpha: 0.1),
      100: AppColors.primaryBlue.withValues(alpha: 0.2),
      200: AppColors.primaryBlue.withValues(alpha: 0.3),
      300: AppColors.primaryBlue.withValues(alpha: 0.4),
      400: AppColors.primaryBlue.withValues(alpha: 0.5),
      500: AppColors.primaryBlue.withValues(alpha: 0.6),
      600: AppColors.primaryBlue.withValues(alpha: 0.7),
      700: AppColors.primaryBlue.withValues(alpha: 0.8),
      800: AppColors.primaryBlue.withValues(alpha: 0.9),
      900: AppColors.primaryBlue,
    }),
    scaffoldBackgroundColor: Colors.black,
    textTheme: ResponsiveTextTheme.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      fontFamily: 'raleway',
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: Colors.white,
        textStyle: ResponsiveTextTheme.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      labelStyle: ResponsiveTextTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.accentRed),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 0,
    ),
  );

  // Import text styles for direct access
  static TextStyle? get headingLarge =>
      ResponsiveTextTheme.textTheme.displayLarge;
  static TextStyle? get headingMedium =>
      ResponsiveTextTheme.textTheme.displayMedium;
  static TextStyle? get headingSmall =>
      ResponsiveTextTheme.textTheme.displaySmall;
  static TextStyle? get bodyLarge => ResponsiveTextTheme.textTheme.bodyLarge;
  static TextStyle? get bodyMedium => ResponsiveTextTheme.textTheme.bodyMedium;
  static TextStyle? get bodySmall => ResponsiveTextTheme.textTheme.bodySmall;
  static TextStyle? get label => ResponsiveTextTheme.textTheme.labelMedium;
  static TextStyle? get button => ResponsiveTextTheme.textTheme.labelLarge;
}
