import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/kpi_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_image.dart';
import '../widgets/charts/cost_trend_chart.dart';
import '../widgets/charts/risk_distribution_chart.dart';
import '../widgets/charts/workforce_bar_chart.dart';
import '../widgets/charts/schedule_performance_chart.dart';
import '../../providers/project_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Top Greeting Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Admin 👋',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Here is your construction command center overview for today.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => context.go('/projects'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('View All Projects'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 6 Top KPI Cards Grid
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                KpiCard(
                  title: 'Active Projects',
                  value: '12',
                  trend: '+2.3%',
                  isPositive: true,
                  onTap: () => context.go('/projects'),
                ),
                KpiCard(
                  title: 'Total Budget',
                  value: '₹5.4 Cr',
                  trend: '+2.3%',
                  isPositive: true,
                  onTap: () => context.go('/cost-management'),
                ),
                KpiCard(
                  title: 'Total Spent',
                  value: '₹3.8 Cr',
                  trend: '-0.5%',
                  isPositive: true,
                  onTap: () => context.go('/cost-management'),
                ),
                KpiCard(
                  title: 'Active Employees',
                  value: '146',
                  trend: '+2.3%',
                  isPositive: true,
                  onTap: () => context.go('/employees'),
                ),
                KpiCard(
                  title: 'Present Today',
                  value: '128',
                  trend: '87.6%',
                  isPositive: true,
                  onTap: () => context.go('/attendance'),
                ),
                KpiCard(
                  title: 'Risk Score',
                  value: '6.2/10',
                  trend: 'Medium Risk',
                  isPositive: false,
                  trailingWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Moderate',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Analytics Section with Responsive LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 950;

                return Column(
                  children: [
                    // Row 1 Analytics: Cost Trend + Risk Distribution
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(flex: 7, child: CostTrendChart()),
                          SizedBox(width: 24),
                          Expanded(flex: 5, child: RiskDistributionChart()),
                        ],
                      )
                    else
                      Column(
                        children: const [
                          CostTrendChart(),
                          SizedBox(height: 24),
                          RiskDistributionChart(),
                        ],
                      ),

                    const SizedBox(height: 24),

                    // Row 2 Analytics: Workforce Allocation + Schedule Performance
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(flex: 6, child: WorkforceBarChart()),
                          SizedBox(width: 24),
                          Expanded(flex: 6, child: SchedulePerformanceChart()),
                        ],
                      )
                    else
                      Column(
                        children: const [
                          WorkforceBarChart(),
                          SizedBox(height: 24),
                          SchedulePerformanceChart(),
                        ],
                      ),

                    const SizedBox(height: 24),

                    // Row 3: Project Progress Breakdown + Recent Activity Log
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: _buildProjectProgressWidget(ref, projectsState)),
                          const SizedBox(width: 24),
                          Expanded(flex: 5, child: _buildRecentActivityWidget()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildProjectProgressWidget(ref, projectsState),
                          const SizedBox(height: 24),
                          _buildRecentActivityWidget(),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectProgressWidget(WidgetRef ref, dynamic projectsState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Project Progress',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () => context.go('/projects'),
                  child: Text(
                    'View All →',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projectsState.projects.take(4).length,
            separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final p = projectsState.projects[index];
              return InkWell(
                onTap: () {
                  ref.read(selectedProjectIdProvider.notifier).state = p.id;
                  context.go('/projects/${p.id}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomImage(
                          imageUrl: p.imageUrl,
                          width: 44,
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 14),
                        SizedBox(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${p.client} • ${p.location}',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(p.progress * 100).toInt()}%',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '₹${p.spentCr}Cr/₹${p.budgetCr}Cr',
                                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: p.progress,
                                backgroundColor: const Color(0xFFF1F5F9),
                                color: p.status == 'Delayed'
                                    ? AppColors.danger
                                    : (p.status == 'At Risk' ? AppColors.warning : AppColors.success),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        StatusBadge(status: p.status),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Site Activity',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.engineering_outlined,
            color: AppColors.primary,
            title: 'Engineer updated project progress',
            subtitle: 'Green Valley Residence • 72% milestone reached',
            time: '10 mins ago',
          ),
          _buildActivityItem(
            icon: Icons.how_to_reg_outlined,
            color: AppColors.success,
            title: '14 workers checked in via GPS',
            subtitle: 'City Mall Extension site team',
            time: '35 mins ago',
          ),
          _buildActivityItem(
            icon: Icons.local_shipping_outlined,
            color: AppColors.warning,
            title: 'Material received on site',
            subtitle: '120 Bags Cement • Green Valley',
            time: '1 hour ago',
          ),
          _buildActivityItem(
            icon: Icons.receipt_long_outlined,
            color: AppColors.info,
            title: 'Expense submitted for approval',
            subtitle: '₹4,85,000 for Steel Rod batch 4',
            time: '3 hours ago',
          ),
          _buildActivityItem(
            icon: Icons.description_outlined,
            color: Colors.purple,
            title: 'Daily report uploaded with site photos',
            subtitle: 'By Arun Kumar (Site Supervisor)',
            time: '5 hours ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
