// core/network/http_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nrcs/core/env.dart';
import 'dart:io';

class HttpClient {
  static late final Dio dio;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    // Ensure Env is initialized first to load .env variables
    await Env.init();
    
    // Now initialize Dio with the correct base URL from environment
    // Directly access the environment variables as a workaround
    bool onLan = false;
    try {
      final result = await InternetAddress.lookup('10.0.0.5');
      onLan = result.isNotEmpty;
    } catch (_) {
      onLan = false;
    }
    
    final String baseUrl = onLan 
      ? dotenv.env['API_BASE_LAN'] ?? 'http://10.0.0.5:3000' 
      : dotenv.env['API_BASE_PROD'] ?? 'https://api.nrcs.example.com';
      
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    _isInitialized = true;
  }

  static void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}