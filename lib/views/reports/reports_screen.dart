import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                      Text('Reports Center', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('Export executive PDF & Excel summaries for clients and stakeholders.', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting Excel report...')));
                      },
                      icon: const Icon(Icons.table_chart_outlined, size: 16),
                      label: const Text('Export Excel'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting PDF report...')));
                      },
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Export PDF'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 1100 ? 3 : (width > 650 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: width > 1100 ? 2.4 : (width > 650 ? 2.2 : 2.0),
                  children: [
                    _buildReportCard(context, 'Project Report', 'Overall progress, milestones, and site completion rates.', Icons.business_outlined),
                    _buildReportCard(context, 'Cost Report', 'Budget vs spending variance and expense audits.', Icons.account_balance_wallet_outlined),
                    _buildReportCard(context, 'Attendance Report', 'Daily, weekly, and monthly worker attendance logs.', Icons.people_outline_rounded),
                    _buildReportCard(context, 'Material Report', 'Material receipts, consumption rate, and stock alerts.', Icons.inventory_2_outlined),
                    _buildReportCard(context, 'Daily Progress Report', 'Site daily update timeline and verified photos.', Icons.photo_library_outlined),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening $title summary...')));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('View Report', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 13, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
