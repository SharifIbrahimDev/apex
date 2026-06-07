import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_metrics_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRepository(apiClient);
});

final adminMetricsProvider = FutureProvider<AdminDashboardMetrics>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getAdminMetrics();
});

final staffMetricsProvider = FutureProvider<StaffDashboardMetrics>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getStaffMetrics();
});
