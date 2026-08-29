import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class RiskDistributionChart extends StatelessWidget {
  const RiskDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Risk Distribution',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    startDegreeOffset: 180,
                    sections: [
                      PieChartSectionData(
                        color: AppColors.success,
                        value: 50,
                        title: '',
                        radius: 16,
                      ),
                      PieChartSectionData(
                        color: AppColors.warning,
                        value: 30,
                        title: '',
                        radius: 16,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFF97316),
                        value: 12,
                        title: '',
                        radius: 16,
                      ),
                      PieChartSectionData(
                        color: AppColors.danger,
                        value: 8,
                        title: '',
                        radius: 16,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '80',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Medium',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRiskIndicator(AppColors.success, 'Low'),
              _buildRiskIndicator(AppColors.warning, 'Medium'),
              _buildRiskIndicator(const Color(0xFFF97316), 'High'),
              _buildRiskIndicator(AppColors.danger, 'Critical'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
