import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expenses_provider.dart';

class ExpensesListScreen extends ConsumerWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/expenses/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: expensesAsync.when(
          loading: () => _buildSkeletonLoader(context),
          error: (e, st) => Center(
            key: const ValueKey('error'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load expenses', style: Theme.of(context).textTheme.titleLarge),
                Text(e.toString(), style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => ref.invalidate(expensesProvider), child: const Text('Retry')),
              ],
            ),
          ),
          data: (expenses) {
            return RefreshIndicator(
              key: const ValueKey('data'),
              onRefresh: () async => ref.invalidate(expensesProvider),
              child: expenses.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, size: 100, color: Colors.grey.shade300),
                            const SizedBox(height: 24),
                            Text('No expenses yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Tap the + button to log an expense.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                      itemCount: expenses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.money_off, color: Colors.red),
                            ),
                            title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text(expense.expenseDate.toString().split(' ')[0], style: TextStyle(color: Colors.grey.shade500)),
                            trailing: Text('-₦${expense.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
