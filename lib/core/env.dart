// core/env.dart
import 'dart:io';

class Env {
  static late final bool onLan;

  static Future<void> init() async {
    // Simple LAN probe; in real app use platform-specific checks
    try {
      final result = await InternetAddress.lookup('10.0.0.5');
      onLan = result.isNotEmpty;
    } catch (_) {
      onLan = false;
    }
  }

  static String apiBase() => onLan ? 'http://10.0.0.5:3000' : 'https://api.nrcs.example.com';
  static String wsBase() => onLan ? 'ws://10.0.0.5:3000' : 'wss://api.nrcs.example.com';
}
