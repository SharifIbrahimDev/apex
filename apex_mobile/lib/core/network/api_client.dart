import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://apex-api.daynapp.com/api'; // Live server

  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
    'Accept': 'application/json',
  })) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
          }
          return handler.next(e);
        },
      ),
    );
  }
}
