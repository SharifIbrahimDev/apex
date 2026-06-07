import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../auth/models/user_model.dart';

class UsersRepository {
  final ApiClient apiClient;

  UsersRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.dio.get('/users');
      return (response.data as List).map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch users');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/users', data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create user');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
