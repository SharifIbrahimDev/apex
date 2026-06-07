import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final message = e.response?.data['message'] ?? 'Authentication failed';
        throw Exception(message);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> logout() async {
    try {
      await apiClient.dio.post('/logout');
    } catch (e) {
      // Ignore errors on logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }
}
