import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CostTrendChart extends StatelessWidget {
  const CostTrendChart({super.key});

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
                'Cost Trend Analysis',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildLegend(color: AppColors.primary, label: 'Actual Cost'),
                  const SizedBox(width: 16),
                  _buildLegend(color: const Color(0xFF94A3B8), label: 'Baseline Cost'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1500,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 1500,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value / 100).toStringAsFixed(0)}k',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual Cost Line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1500),
                      FlSpot(1, 1400),
                      FlSpot(2, 1800),
                      FlSpot(3, 2100),
                      FlSpot(4, 3400),
                      FlSpot(5, 2900),
                      FlSpot(6, 3200),
                      FlSpot(7, 3100),
                      FlSpot(8, 3800),
                      FlSpot(9, 4100),
                      FlSpot(10, 4200),
                      FlSpot(11, 4500),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.08),
                    ),
                  ),
                  // Baseline Line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 2000),
                      FlSpot(1, 2200),
                      FlSpot(2, 2400),
                      FlSpot(3, 2600),
                      FlSpot(4, 3200),
                      FlSpot(5, 3300),
                      FlSpot(6, 3400),
                      FlSpot(7, 3600),
                      FlSpot(8, 3700),
                      FlSpot(9, 3900),
                      FlSpot(10, 4000),
                      FlSpot(11, 4200),
                    ],
                    isCurved: true,
                    color: const Color(0xFFCBD5E1),
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
