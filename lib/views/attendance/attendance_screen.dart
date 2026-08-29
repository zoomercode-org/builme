import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/kpi_card.dart';
import '../../providers/employee_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

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
                      Text('Attendance', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('GPS & biometric attendance verification log for site teams.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.cardBorder)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Text('Today, 27 May 2025', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

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
                    KpiCard(title: 'Total Workers', value: '146', trend: 'Registered'),
                    KpiCard(title: 'Present Today', value: '128', trend: '87.6% rate'),
                    KpiCard(title: 'Absent', value: '10', trend: '6.8% rate', isPositive: false),
                    KpiCard(title: 'Late Arrival', value: '8', trend: '5.6% rate', isPositive: false),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

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
                            CircleAvatar(radius: 18, backgroundImage: NetworkImage(emp.avatarUrl)),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(emp.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text(emp.role, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            SizedBox(width: 160, child: Text(emp.projectName, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                            SizedBox(width: 110, child: Text('In: ${emp.checkInTime}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                            SizedBox(width: 110, child: Text('Out: ${emp.checkOutTime}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                            StatusBadge(status: emp.isVerified ? 'Verified' : 'Pending'),
                            const SizedBox(width: 12),
                            StatusBadge(status: emp.attendanceToday),
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
