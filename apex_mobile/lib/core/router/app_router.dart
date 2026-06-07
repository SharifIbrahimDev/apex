import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/sales/presentation/screens/sales_list_screen.dart';
import '../../features/sales/presentation/screens/sale_form_screen.dart';
import '../../features/expenses/presentation/screens/expenses_list_screen.dart';
import '../../features/expenses/presentation/screens/expense_form_screen.dart';
import '../../features/services/presentation/screens/services_list_screen.dart';
import '../../features/services/presentation/screens/service_form_screen.dart';
import '../../features/users/presentation/screens/users_list_screen.dart';
import '../../features/users/presentation/screens/user_form_screen.dart';
import '../widgets/app_navigation_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppNavigationShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/sales',
          builder: (context, state) => const SalesListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const SaleFormScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/expenses',
          builder: (context, state) => const ExpensesListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const ExpenseFormScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const ServiceFormScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const UserFormScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
