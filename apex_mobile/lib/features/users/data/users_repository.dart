import '../../../core/network/api_client.dart';
import '../../auth/models/user_model.dart';

class UsersRepository {
  final ApiClient apiClient;

  UsersRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.dio.get('/users');
    return (response.data as List).map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('/users', data: data);
    return UserModel.fromJson(response.data);
  }
}
