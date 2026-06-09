import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../data/sales_repository.dart';
import '../models/sale_model.dart';

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SalesRepository(apiClient);
});

class SalesNotifier extends AsyncNotifier<List<SaleModel>> {
  @override
  FutureOr<List<SaleModel>> build() async {
    final repository = ref.watch(salesRepositoryProvider);
    return await repository.getSales();
  }

  Future<void> addSale(Map<String, dynamic> data) async {
    final repository = ref.read(salesRepositoryProvider);
    final newSale = await repository.createSale(data);
    state = AsyncData([newSale, ...?state.value]);
    ref.invalidate(adminMetricsProvider);
    ref.invalidate(staffMetricsProvider);
  }
}

final salesProvider = AsyncNotifierProvider<SalesNotifier, List<SaleModel>>(() {
  return SalesNotifier();
});
