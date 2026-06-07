import '../../../core/network/api_client.dart';
import '../models/expense_model.dart';

class ExpensesRepository {
  final ApiClient apiClient;

  ExpensesRepository(this.apiClient);

  Future<List<ExpenseModel>> getExpenses() async {
    final response = await apiClient.dio.get('/expenses');
    return (response.data['data'] as List).map((json) => ExpenseModel.fromJson(json)).toList();
  }

  Future<ExpenseModel> createExpense(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('/expenses', data: data);
    return ExpenseModel.fromJson(response.data);
  }
}
