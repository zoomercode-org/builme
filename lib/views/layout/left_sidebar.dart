import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class LeftSidebar extends ConsumerWidget {
  final String currentPath;

  const LeftSidebar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(
          right: BorderSide(color: AppColors.sidebarBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  path: '/dashboard',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.business_outlined,
                  label: 'Projects',
                  path: '/projects',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline_rounded,
                  label: 'Employees',
                  path: '/employees',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.how_to_reg_outlined,
                  label: 'Attendance',
                  path: '/attendance',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  label: 'Materials',
                  path: '/materials',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Cost Management',
                  path: '/cost-management',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.insert_chart_outlined_rounded,
                  label: 'Reports',
                  path: '/reports',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.folder_open_outlined,
                  label: 'Documents',
                  path: '/documents',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  path: '/settings',
                ),
              ],
            ),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.sidebarBorder, width: 1),
              ),
            ),
            child: Column(
              children: [
                _buildBottomItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('BuilMe Support: support@zoomercode.com')),
                    );
                  },
                ),
                const SizedBox(height: 4),
                _buildBottomItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: AppColors.danger,
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String path,
  }) {
    final bool isActive = currentPath == path || (path != '/dashboard' && currentPath.startsWith(path));

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => context.go(path),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.sidebarItemActive : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.sidebarTextActive : AppColors.sidebarText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppColors.sidebarTextActive : AppColors.sidebarText,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.sidebarTextActive,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? AppColors.sidebarText;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: itemColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
