import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/dashboard_metrics_model.dart';
import '../../providers/dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(adminMetricsProvider);

    return metricsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (metrics) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminMetricsProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overview', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Here is your business summary today.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                const SizedBox(height: 32),
                _buildSummaryCards(context, metrics),
                const SizedBox(height: 32),
                _buildRevenueChart(context, metrics),
                const SizedBox(height: 32),
                _buildRecentTransactions(context, metrics.recentTransactions),
              ],
            ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context, AdminDashboardMetrics metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth > 800 ? 1.8 : 1.3,
          children: [
            _MetricCard(title: 'Sales Today', value: '₦${metrics.totalSalesToday}', icon: Icons.trending_up, color: const Color(0xFF4CAF50)),
            _MetricCard(title: 'Expenses Today', value: '₦${metrics.totalExpensesToday}', icon: Icons.trending_down, color: const Color(0xFFE53935)),
            _MetricCard(title: 'Net Profit', value: '₦${metrics.netProfitToday}', icon: Icons.account_balance_wallet, color: const Color(0xFF1E88E5)),
            _MetricCard(title: 'Weekly Rev', value: '₦${metrics.weeklyRevenue}', icon: Icons.insert_chart, color: const Color(0xFFFFB300)),
          ],
        );
      }
    );
  }

  Widget _buildRevenueChart(BuildContext context, AdminDashboardMetrics metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Revenue Growth', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: metrics.yearlyRevenue * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
                          switch (value.toInt()) {
                            case 0: return const Text('Week', style: style);
                            case 1: return const Text('Month', style: style);
                            case 2: return const Text('Year', style: style);
                            default: return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (metrics.yearlyRevenue / 4) > 0 ? (metrics.yearlyRevenue / 4) : 1000,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: metrics.weeklyRevenue,
                          gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF81C784)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                          width: 40,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: metrics.monthlyRevenue,
                          gradient: const LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                          width: 40,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: metrics.yearlyRevenue,
                          gradient: const LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFFD54F)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                          width: 40,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, List<dynamic> transactions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Recent Transactions', 
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/activities'), 
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
               const Padding(padding: EdgeInsets.all(16), child: Text('No recent transactions.')),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.receipt_long, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(tx.service?.name ?? 'Unknown Service', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(tx.transactionDate.toString().split(' ')[0] + (tx.user != null ? ' • ${tx.user!.name.split(' ').first}' : ''), style: TextStyle(color: Colors.grey.shade500)),
                  trailing: Text('₦${tx.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              )
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
