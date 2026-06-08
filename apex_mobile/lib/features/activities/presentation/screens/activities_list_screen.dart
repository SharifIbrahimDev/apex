import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../sales/providers/sales_provider.dart';
import '../../../expenses/providers/expenses_provider.dart';
import '../../../sales/models/sale_model.dart';
import '../../../expenses/models/expense_model.dart';
import '../../../auth/providers/auth_provider.dart';

final activitiesProvider = Provider<AsyncValue<List<dynamic>>>((ref) {
  final sales = ref.watch(salesProvider);
  final expenses = ref.watch(expensesProvider);

  if (sales.isLoading || expenses.isLoading) return const AsyncLoading();
  if (sales.hasError) return AsyncError(sales.error!, sales.stackTrace!);
  if (expenses.hasError) return AsyncError(expenses.error!, expenses.stackTrace!);

  final allItems = <dynamic>[];
  if (sales.hasValue) allItems.addAll(sales.value!);
  if (expenses.hasValue) allItems.addAll(expenses.value!);

  allItems.sort((a, b) {
    DateTime dateA = a is SaleModel ? a.transactionDate : (a as ExpenseModel).expenseDate;
    DateTime dateB = b is SaleModel ? b.transactionDate : (b as ExpenseModel).expenseDate;
    return dateB.compareTo(dateA);
  });

  return AsyncData(allItems);
});

class ActivitiesListScreen extends ConsumerWidget {
  const ActivitiesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider);
    final currentUser = ref.watch(authProvider).value;
    final isAdmin = currentUser?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Activities', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 64),
              const SizedBox(height: 16),
              Text('Failed to load activities', style: Theme.of(context).textTheme.titleLarge),
              Text(e.toString(), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(salesProvider);
                  ref.refresh(expensesProvider);
                }, 
                child: const Text('Retry')
              )
            ],
          ),
        ),
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  Text('No Activities Yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                  const SizedBox(height: 8),
                  Text('Your recent transactions will appear here.', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(salesProvider);
              // ignore: unused_result
              ref.refresh(expensesProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final activity = activities[index];
                
                if (activity is SaleModel) {
                  final dateStr = activity.transactionDate.toString().split(' ')[0];
                  final userStr = isAdmin && activity.user != null ? ' • ${activity.user!.name.split(' ').first}' : '';
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withValues(alpha: 0.1),
                      child: const Icon(Icons.arrow_downward, color: Colors.green),
                    ),
                    title: Text(activity.service?.name ?? 'Sale', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$dateStr$userStr', style: TextStyle(color: Colors.grey.shade500)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('+ ₦${activity.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        const SizedBox(height: 4),
                        Text(activity.paymentMethod, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  );
                } else if (activity is ExpenseModel) {
                  final dateStr = activity.expenseDate.toString().split(' ')[0];
                  final userStr = isAdmin && activity.user != null ? ' • ${activity.user!.name.split(' ').first}' : '';
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      child: const Icon(Icons.arrow_upward, color: Colors.red),
                    ),
                    title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$dateStr$userStr', style: TextStyle(color: Colors.grey.shade500)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('- ₦${activity.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                        const SizedBox(height: 4),
                        Text('Expense', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
