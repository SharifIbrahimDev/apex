import '../../../core/network/api_client.dart';
import '../models/dashboard_metrics_model.dart';

class DashboardRepository {
  final ApiClient apiClient;

  DashboardRepository(this.apiClient);

  Future<AdminDashboardMetrics> getAdminMetrics() async {
    final response = await apiClient.dio.get('/dashboard/admin');
    return AdminDashboardMetrics.fromJson(response.data);
  }

  Future<StaffDashboardMetrics> getStaffMetrics() async {
    final response = await apiClient.dio.get('/dashboard/staff');
    return StaffDashboardMetrics.fromJson(response.data);
  }
}
