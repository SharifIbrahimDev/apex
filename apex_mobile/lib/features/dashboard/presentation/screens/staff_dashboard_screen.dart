import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/dashboard_metrics_model.dart';
import '../../../auth/providers/auth_provider.dart';

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(staffMetricsProvider);
    final user = ref.watch(authProvider).value;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: metricsAsync.when(
        loading: () => _buildSkeletonLoader(context, key: const ValueKey('loading')),
        error: (e, st) => Scaffold(key: const ValueKey('error'), body: Center(child: Text('Error: $e'))),
        data: (metrics) {
          return Scaffold(
            key: const ValueKey('data'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, ${user?.name.split(' ').first ?? 'Staff'}', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Your performance overview for today.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  const SizedBox(height: 32),
                  _buildSummaryCards(context, metrics),
                  const SizedBox(height: 32),
                  _buildRecentTransactions(context, metrics.recentActivities),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context, {Key? key}) {
    return Scaffold(
      key: key,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 150, height: 32, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 8),
            Container(width: 250, height: 16, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: Container(height: 120, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)))),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 120, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)))),
              ],
            ),
            const SizedBox(height: 32),
            Container(width: double.infinity, height: 300, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, StaffDashboardMetrics metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 2 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _MetricCard(title: 'My Sales (Count)', value: '${metrics.mySalesToday}', icon: Icons.point_of_sale, color: const Color(0xFF4CAF50)),
            _MetricCard(title: 'My Revenue Today', value: '₦${metrics.myRevenueToday}', icon: Icons.money, color: const Color(0xFF1E88E5)),
          ],
        );
      }
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
                    'My Recent Activities', 
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
               const Padding(padding: EdgeInsets.all(16), child: Text('You have no recent activities.')),
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
                    child: Icon(Icons.receipt, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(tx.service?.name ?? 'Unknown Service', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(tx.transactionDate.toString().split(' ')[0], style: TextStyle(color: Colors.grey.shade500)),
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
