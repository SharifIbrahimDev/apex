import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/services_repository.dart';
import '../models/service_model.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ServicesRepository(apiClient);
});

class ServicesNotifier extends AsyncNotifier<List<ServiceModel>> {
  @override
  FutureOr<List<ServiceModel>> build() async {
    final repository = ref.watch(servicesRepositoryProvider);
    return await repository.getServices();
  }

  Future<void> addService(Map<String, dynamic> data) async {
    final repository = ref.read(servicesRepositoryProvider);
    final newService = await repository.createService(data);
    state = AsyncData([...?state.value, newService]);
  }
}

final servicesProvider = AsyncNotifierProvider<ServicesNotifier, List<ServiceModel>>(() {
  return ServicesNotifier();
});
