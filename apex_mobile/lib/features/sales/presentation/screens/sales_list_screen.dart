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
      appBar: AppBar(title: const Text('Sales')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/sales/add'),
        child: const Icon(Icons.add),
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (sales) {
          if (sales.isEmpty) {
            return const Center(child: Text('No sales found.'));
          }
          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.receipt)),
                title: Text(sale.service?.name ?? 'Sale #${sale.id}'),
                subtitle: Text('₦${sale.amount} - ${sale.paymentMethod}'),
                trailing: Text(sale.transactionDate.toString().split(' ')[0]),
              );
            },
          );
        },
      ),
    );
  }
}
