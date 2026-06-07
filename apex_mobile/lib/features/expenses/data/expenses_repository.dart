import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/expense_model.dart';

class ExpensesRepository {
  final ApiClient apiClient;

  ExpensesRepository(this.apiClient);

  Future<List<ExpenseModel>> getExpenses() async {
    try {
      final response = await apiClient.dio.get('/expenses');
      return (response.data['data'] as List).map((json) => ExpenseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch expenses');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<ExpenseModel> createExpense(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/expenses', data: data);
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create expense');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
