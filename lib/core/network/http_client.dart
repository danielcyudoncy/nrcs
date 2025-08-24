// core/network/http_client.dart
import 'package:dio/dio.dart';
import 'package:nrcs/core/env.dart';

class HttpClient {
  static final Dio dio = Dio(BaseOptions(baseUrl: Env.apiBase()));

  static void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
