import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/sale_model.dart';

class SalesRepository {
  final ApiClient apiClient;

  SalesRepository(this.apiClient);

  Future<List<SaleModel>> getSales() async {
    try {
      final response = await apiClient.dio.get('/sales');
      return (response.data['data'] as List).map((json) => SaleModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch sales');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<SaleModel> createSale(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/sales', data: data);
      return SaleModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create sale');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
