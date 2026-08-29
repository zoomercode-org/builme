import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/kpi_card.dart';
import '../widgets/charts/cost_trend_chart.dart';
import '../../providers/expense_provider.dart';

class CostManagementScreen extends ConsumerWidget {
  const CostManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

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
                      Text('Cost Management', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Budget vs actual spending breakdown, cost trends, and expense approvals.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('+ Add Expense'),
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
                    KpiCard(title: 'Total Budget', value: '₹5.4 Cr', trend: 'Approved'),
                    KpiCard(title: 'Total Spent', value: '₹3.8 Cr', trend: '70.3% used'),
                    KpiCard(title: 'Pending Approval', value: '₹24 L', trend: '3 claims', isPositive: false),
                    KpiCard(title: 'Remaining Budget', value: '₹1.6 Cr', trend: '29.7% safe'),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            const CostTrendChart(),

            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Expense Transactions Log', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expenses.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                    itemBuilder: (context, index) {
                      final exp = expenses[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 700),
                            child: Row(
                              children: [
                                SizedBox(width: 90, child: Text(exp.date, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 240,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(exp.description, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                      Text('${exp.projectName} • ${exp.category}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text('₹${exp.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text('By: ${exp.submittedBy}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                                ),
                                StatusBadge(status: exp.status),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
