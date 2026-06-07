import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';

class AppNavigationShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppNavigationShell({super.key, required this.child});

  @override
  ConsumerState<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends ConsumerState<AppNavigationShell> {
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/sales')) return 1;
    if (location.startsWith('/expenses')) return 2;
    if (location.startsWith('/services')) return 3;
    if (location.startsWith('/users')) return 4;
    return 0;
  }

  void _onItemTapped(int index, String role) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/sales');
        break;
      case 2:
        context.go('/expenses');
        break;
      case 3:
        if (role == 'admin') context.go('/services');
        break;
      case 4:
        if (role == 'admin') context.go('/users');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final role = user?.role ?? 'staff';
    final isAdmin = role == 'admin';

    final currentIndex = _calculateSelectedIndex(context);

    // Build items based on role
    final List<NavigationDestination> destinations = [
      const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Sales'),
      const NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Expenses'),
      if (isAdmin) const NavigationDestination(icon: Icon(Icons.design_services_outlined), selectedIcon: Icon(Icons.design_services), label: 'Services'),
      if (isAdmin) const NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users'),
    ];

    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: isWideScreen
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => _onItemTapped(index, role),
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations.map((d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  )).toList(),
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: Icon(Icons.business_center, color: Theme.of(context).colorScheme.primary, size: 40),
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            ref.read(authProvider.notifier).logout();
                            context.go('/login');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: widget.child),
              ],
            )
          : widget.child,
      bottomNavigationBar: !isWideScreen
          ? NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) => _onItemTapped(index, role),
              destinations: destinations,
            )
          : null,
    );
  }
}
