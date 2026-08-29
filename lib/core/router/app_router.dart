import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../views/auth/login_screen.dart';
import '../../views/layout/admin_shell_layout.dart';
import '../../views/dashboard/dashboard_screen.dart';
import '../../views/projects/projects_screen.dart';
import '../../views/project_details/project_details_screen.dart';
import '../../views/employees/employees_screen.dart';
import '../../views/attendance/attendance_screen.dart';
import '../../views/materials/materials_screen.dart';
import '../../views/cost_management/cost_management_screen.dart';
import '../../views/reports/reports_screen.dart';
import '../../views/documents/documents_screen.dart';
import '../../views/settings/settings_screen.dart';
import '../../providers/auth_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AdminShellLayout(
            currentPath: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsScreen(),
          ),
          GoRoute(
            path: '/projects/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'proj-1';
              return ProjectDetailsScreen(projectId: id);
            },
          ),
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeesScreen(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/materials',
            builder: (context, state) => const MaterialsScreen(),
          ),
          GoRoute(
            path: '/cost-management',
            builder: (context, state) => const CostManagementScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
