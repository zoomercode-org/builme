import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? placeholderLabel;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderLabel,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: br,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder(context, isSkeleton: true);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context, isSkeleton: false);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, {required bool isSkeleton}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSkeleton
              ? [const Color(0xFFE2E8F0), const Color(0xFFF1F5F9)]
              : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
        ),
      ),
      child: Stack(
        children: [
          // Background grid pattern simulation
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _GridPatternPainter(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSkeleton ? Colors.white.withValues(alpha: 0.5) : AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.architecture_rounded,
                    color: isSkeleton ? AppColors.textMuted : AppColors.primary,
                    size: width < 100 ? 18 : 28,
                  ),
                ),
                if (width > 120 && height > 70) ...[
                  const SizedBox(height: 6),
                  Text(
                    placeholderLabel ?? 'BuilMe Site View',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSkeleton ? AppColors.textMuted : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    const double step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
