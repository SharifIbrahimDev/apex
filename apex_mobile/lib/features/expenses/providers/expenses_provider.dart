import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/expenses_repository.dart';
import '../models/expense_model.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExpensesRepository(apiClient);
});

class ExpensesNotifier extends AsyncNotifier<List<ExpenseModel>> {
  @override
  FutureOr<List<ExpenseModel>> build() async {
    final repository = ref.watch(expensesRepositoryProvider);
    return await repository.getExpenses();
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    final repository = ref.read(expensesRepositoryProvider);
    final newExpense = await repository.createExpense(data);
    state = AsyncData([newExpense, ...?state.value]);
  }
}

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<ExpenseModel>>(() {
  return ExpensesNotifier();
});
