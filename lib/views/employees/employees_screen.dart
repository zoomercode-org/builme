import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/kpi_card.dart';
import '../widgets/worker_avatar.dart';
import '../widgets/site_image.dart';
import '../sheets/add_employee_sheet.dart';
import '../../providers/employee_provider.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      onPressed: () => setState(() => _isDrawerOpen = true),
                      icon: const Icon(Icons.person_add_alt_outlined, size: 18),
                      label: const Text('+ Add Employee'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Site Team Allocations (Width: 280px, Height: 160px)
                Text('Project Workforce Distribution', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'Green Valley Team (46 Staff)',
                          tag: 'Engineers & Masons',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'City Mall Extension (38 Staff)',
                          tag: 'Steel Fixers & Safety',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'Ocean View Villa (22 Staff)',
                          tag: 'MEP Engineers',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Compact KPI Cards Grid (Width: 230px, Height: 120px)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    KpiCard(title: 'Total Employees', value: '146', trend: '+4 this month'),
                    KpiCard(title: 'Active Today', value: '128', trend: '87.6% active'),
                    KpiCard(title: 'On Leave', value: '8', trend: '5.4% leave'),
                    KpiCard(title: 'Site Supervisors', value: '24', trend: 'Fully staffed'),
                  ],
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

          // Slide-Over Drawer for "+ Add Employee"
          if (_isDrawerOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isDrawerOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          if (_isDrawerOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AddEmployeeSheet(
                onClose: () => setState(() => _isDrawerOpen = false),
              ),
            ),
        ],
      ),
    );
  }
}
