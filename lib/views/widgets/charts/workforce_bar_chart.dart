import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WorkforceBarChart extends StatelessWidget {
  const WorkforceBarChart({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workforce Allocation',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildLegend(AppColors.primary, 'Allocated'),
                  const SizedBox(width: 12),
                  _buildLegend(const Color(0xFFE2E8F0), 'Available'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 60,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 15,
                      getTitlesWidget: (val, meta) => Text(
                        val.toInt().toString(),
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (val, meta) {
                        const roles = ['Site Workers', 'Engineers', 'Supervisors', 'Admin', 'Safety'];
                        if (val.toInt() >= 0 && val.toInt() < roles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              roles[val.toInt()],
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (val) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
                ),
                barGroups: [
                  _buildBarGroup(0, 36, 52),
                  _buildBarGroup(1, 28, 42),
                  _buildBarGroup(2, 14, 18),
                  _buildBarGroup(3, 23, 30),
                  _buildBarGroup(4, 15, 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double allocated, double available) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: allocated,
          color: AppColors.primary,
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: available,
          color: const Color(0xFFCBD5E1),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
