import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/service_model.dart';

class ServicesRepository {
  final ApiClient apiClient;

  ServicesRepository(this.apiClient);

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await apiClient.dio.get('/services');
      return (response.data as List).map((json) => ServiceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch services');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<ServiceModel> createService(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/services', data: data);
      return ServiceModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create service');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
