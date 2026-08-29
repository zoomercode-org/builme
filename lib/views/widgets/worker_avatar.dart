import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const WorkerAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : 'W';

    final Color bgColor = _getBgColor(name);

    Widget buildInitialsFallback() {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }

    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return buildInitialsFallback();
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: ClipOval(
        child: Image.network(
          avatarUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return buildInitialsFallback();
          },
        ),
      ),
    );
  }

  Color _getBgColor(String text) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF3B82F6),
    ];
    return colors[text.hashCode.abs() % colors.length];
  }
}
