import '../../../core/network/api_client.dart';
import '../models/service_model.dart';

class ServicesRepository {
  final ApiClient apiClient;

  ServicesRepository(this.apiClient);

  Future<List<ServiceModel>> getServices() async {
    final response = await apiClient.dio.get('/services');
    return (response.data as List).map((json) => ServiceModel.fromJson(json)).toList();
  }

  Future<ServiceModel> createService(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('/services', data: data);
    return ServiceModel.fromJson(response.data);
  }
}
