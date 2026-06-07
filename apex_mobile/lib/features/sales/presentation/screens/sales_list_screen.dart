import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/sales_provider.dart';

class SalesListScreen extends ConsumerWidget {
  const SalesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales'), centerTitle: true, elevation: 0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/sales/add'),
        icon: const Icon(Icons.add),
        label: const Text('New Sale'),
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 64),
              const SizedBox(height: 16),
              Text('Failed to load sales', style: Theme.of(context).textTheme.titleLarge),
              Text(e.toString(), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.refresh(salesProvider), child: const Text('Retry'))
            ],
          ),
        ),
        data: (sales) {
          if (sales.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  Text('No Sales Yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                  const SizedBox(height: 8),
                  Text('Tap the + button to record a new sale.', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(salesProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sales.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sale = sales[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(sale.service?.name ?? 'Sale #${sale.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.payment, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(sale.paymentMethod, style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('₦${sale.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        const SizedBox(height: 4),
                        Text(sale.transactionDate.toString().split(' ')[0], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
