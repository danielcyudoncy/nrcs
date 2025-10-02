// core/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class Env {
  static late final bool onLan;

  static Future<void> init() async {
    // Load environment variables from .env file
    await dotenv.load(fileName: ".env");
    
    // Simple LAN probe; in real app use platform-specific checks
    try {
      final result = await InternetAddress.lookup('10.0.0.5');
      onLan = result.isNotEmpty;
    } catch (_) {
      onLan = false;
    }
  }


}