import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/project.dart';
import '../status_badge.dart';

class GanttTimelineWidget extends StatelessWidget {
  final List<ProjectMilestone> milestones;

  const GanttTimelineWidget({super.key, required this.milestones});

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
              Flexible(
                child: Text(
                  'Construction Milestone Gantt Timeline',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 12,
                children: [
                  _buildLegend(AppColors.success, 'Completed'),
                  _buildLegend(AppColors.warning, 'In Progress'),
                  _buildLegend(const Color(0xFFCBD5E1), 'Not Started'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 800),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.2),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.0),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(3.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
                    ),
                    children: [
                      _buildTableHeader('Task / Milestone'),
                      _buildTableHeader('Planned Start'),
                      _buildTableHeader('Planned End'),
                      _buildTableHeader('Progress'),
                      _buildTableHeader('Status'),
                      _buildTableHeader('Timeline Bar'),
                    ],
                  ),
                  ...milestones.map((m) {
                    Color barColor;
                    if (m.progress >= 1.0) {
                      barColor = AppColors.success;
                    } else if (m.progress > 0) {
                      barColor = AppColors.warning;
                    } else {
                      barColor = const Color(0xFFCBD5E1);
                    }

                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Owner: ${m.assignee}',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Text(m.plannedStart, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                        Text(m.plannedEnd, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                        Text(
                          '${(m.progress * 100).toInt()}%',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: barColor),
                        ),
                        StatusBadge(status: m.status),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: m.progress.clamp(0.02, 1.0),
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
