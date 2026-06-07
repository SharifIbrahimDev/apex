import '../../../core/network/api_client.dart';
import '../models/sale_model.dart';

class SalesRepository {
  final ApiClient apiClient;

  SalesRepository(this.apiClient);

  Future<List<SaleModel>> getSales() async {
    final response = await apiClient.dio.get('/sales');
    return (response.data['data'] as List).map((json) => SaleModel.fromJson(json)).toList();
  }

  Future<SaleModel> createSale(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('/sales', data: data);
    return SaleModel.fromJson(response.data);
  }
}
