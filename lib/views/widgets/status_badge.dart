import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'on track':
      case 'completed':
      case 'present':
      case 'verified':
      case 'available':
      case 'approved':
      case 'active':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case 'at risk':
      case 'pending':
      case 'late':
      case 'low stock':
      case 'reorder soon':
      case 'in progress':
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case 'delayed':
      case 'absent':
      case 'overbudget':
      case 'rejected':
      case 'critical':
        bg = AppColors.dangerLight;
        fg = AppColors.danger;
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
