// core/utils/theme_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nrcs/core/theme/app_theme.dart';

class ThemeController extends GetxController {
  final RxBool isDark = false.obs;

  ThemeData get currentTheme =>
      isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggle() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  void setDark(bool value) {
    isDark.value = value;
    Get.changeTheme(isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}
