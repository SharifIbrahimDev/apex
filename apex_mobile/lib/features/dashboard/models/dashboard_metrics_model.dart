import '../../sales/models/sale_model.dart';

class AdminDashboardMetrics {
  final double totalSalesToday;
  final double totalExpensesToday;
  final double netProfitToday;
  final double weeklyRevenue;
  final double monthlyRevenue;
  final double yearlyRevenue;
  final List<SaleModel> recentTransactions;

  AdminDashboardMetrics({
    required this.totalSalesToday,
    required this.totalExpensesToday,
    required this.netProfitToday,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
    required this.yearlyRevenue,
    required this.recentTransactions,
  });

  factory AdminDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return AdminDashboardMetrics(
      totalSalesToday: double.parse(json['total_sales_today'].toString()),
      totalExpensesToday: double.parse(json['total_expenses_today'].toString()),
      netProfitToday: double.parse(json['net_profit_today'].toString()),
      weeklyRevenue: double.parse(json['weekly_revenue'].toString()),
      monthlyRevenue: double.parse(json['monthly_revenue'].toString()),
      yearlyRevenue: double.parse(json['yearly_revenue'].toString()),
      recentTransactions: (json['recent_transactions'] as List)
          .map((item) => SaleModel.fromJson(item))
          .toList(),
    );
  }
}

class StaffDashboardMetrics {
  final int mySalesToday;
  final double myRevenueToday;
  final List<SaleModel> recentActivities;

  StaffDashboardMetrics({
    required this.mySalesToday,
    required this.myRevenueToday,
    required this.recentActivities,
  });

  factory StaffDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return StaffDashboardMetrics(
      mySalesToday: json['my_sales_today'],
      myRevenueToday: double.parse(json['my_revenue_today'].toString()),
      recentActivities: (json['recent_activities'] as List)
          .map((item) => SaleModel.fromJson(item))
          .toList(),
    );
  }
}
