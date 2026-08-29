import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SiteImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final String? title;
  final String? tag;

  const SiteImage({
    super.key,
    this.imageUrl,
    this.width = 280.0,
    this.height = 160.0,
    this.borderRadius,
    this.title,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(12);

    Widget buildGraphicPlaceholder() {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: br,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Custom Canvas Painting of Construction Crane & Scaffolding
            Positioned.fill(
              child: ClipRRect(
                borderRadius: br,
                child: CustomPaint(
                  painter: ConstructionGraphicPainter(seed: title?.hashCode ?? 42),
                ),
              ),
            ),

            // Top Tag Pill
            if (tag != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Bottom Label Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: br.bottomLeft,
                    bottomRight: br.bottomRight,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  title ?? 'BuilMe Site View',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return buildGraphicPlaceholder();
    }

    return ClipRRect(
      borderRadius: br,
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return buildGraphicPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          // Zero HTTP/CORS error display - fallback cleanly to graphic!
          return buildGraphicPlaceholder();
        },
      ),
    );
  }
}

class ConstructionGraphicPainter extends CustomPainter {
  final int seed;

  ConstructionGraphicPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.4)
      ..strokeWidth = 1.0;

    // Background Grid
    const step = 16.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Building Structure Silhouette
    final bldgPaint = Paint()
      ..color = const Color(0xFF6366F1).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final bldgWidth = size.width * 0.35;
    final bldgHeight = size.height * 0.7;
    final bldgLeft = size.width * 0.15;
    final bldgTop = size.height - bldgHeight;

    canvas.drawRect(
      Rect.fromLTWH(bldgLeft, bldgTop, bldgWidth, bldgHeight),
      bldgPaint,
    );

    // Crane Tower Line
    final cranePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.0;

    final craneX = size.width * 0.7;
    canvas.drawLine(Offset(craneX, size.height), Offset(craneX, size.height * 0.2), cranePaint);
    canvas.drawLine(Offset(craneX - 30, size.height * 0.2), Offset(craneX + 50, size.height * 0.2), cranePaint);
    canvas.drawLine(Offset(craneX + 40, size.height * 0.2), Offset(craneX + 40, size.height * 0.45), cranePaint);

    // Structural Windows
    final windowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (double wy = bldgTop + 10; wy < size.height - 20; wy += 14) {
      for (double wx = bldgLeft + 8; wx < bldgLeft + bldgWidth - 10; wx += 12) {
        canvas.drawRect(Rect.fromLTWH(wx, wy, 8, 8), windowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
