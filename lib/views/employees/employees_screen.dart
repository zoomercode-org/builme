import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/kpi_card.dart';
import '../widgets/worker_avatar.dart';
import '../../providers/employee_provider.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employees',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text('Manage site engineers, supervisors, and workforce allocations.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_outlined, size: 18),
                  label: const Text('+ Add Employee'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Responsive KPI Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 1100 ? 4 : (width > 600 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: width > 1100 ? 2.4 : 2.0,
                  children: const [
                    KpiCard(title: 'Total Employees', value: '146', trend: '+4 this month'),
                    KpiCard(title: 'Active Today', value: '128', trend: '87.6% active'),
                    KpiCard(title: 'On Leave', value: '8', trend: '5.4% leave'),
                    KpiCard(title: 'Site Supervisors', value: '24', trend: 'Fully staffed'),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Employee Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: AppColors.cardShadow,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employees.length,
                separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 700),
                        child: Row(
                          children: [
                            WorkerAvatar(
                              name: emp.name,
                              avatarUrl: emp.avatarUrl,
                              radius: 20,
                            ),
                            const SizedBox(width: 14),
                            SizedBox(
                              width: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(emp.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text(emp.role, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(emp.projectName, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                            ),
                            SizedBox(
                              width: 140,
                              child: Text(emp.phone, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                            ),
                            StatusBadge(status: emp.attendanceToday),
                            const SizedBox(width: 16),
                            StatusBadge(status: emp.status),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
