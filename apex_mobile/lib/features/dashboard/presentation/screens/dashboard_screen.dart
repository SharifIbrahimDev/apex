import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_provider.dart';
import 'admin_dashboard_screen.dart';
import 'staff_dashboard_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: user == null
          ? Center(
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Session Expired. Click to Login Again.'),
              ),
            )
          : user.role == 'admin'
              ? const AdminDashboardScreen()
              : const StaffDashboardScreen(),
    );
  }
}
