import 'package:flutter/material.dart';

class AppColors {
  // Top Header Dark Theme
  static const Color headerBackground = Color(0xFF0B0F19);
  static const Color headerBorder = Color(0xFF1F2937);
  static const Color headerText = Color(0xFFF9FAFB);
  static const Color headerTextMuted = Color(0xFF9CA3AF);

  // Left Sidebar
  static const Color sidebarBackground = Color(0xFFFFFFFF);
  static const Color sidebarBorder = Color(0xFFE2E8F0);
  static const Color sidebarItemHover = Color(0xFFF1F5F9);
  static const Color sidebarItemActive = Color(0xFFEEF2FF);
  static const Color sidebarTextActive = Color(0xFF4F46E5);
  static const Color sidebarText = Color(0xFF475569);

  // Main Canvas
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Accent Colors
  static const Color primary = Color(0xFF6366F1); // Indigo 600
  static const Color primaryHover = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2FF);
  
  static const Color aiGradientStart = Color(0xFF6366F1);
  static const Color aiGradientEnd = Color(0xFF8B5CF6);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status Indicators
  static const Color success = Color(0xFF10B981); // Green - On Track / Present / Verified
  static const Color successLight = Color(0xFFECFDF5);
  
  static const Color warning = Color(0xFFF59E0B); // Amber / Orange - At Risk / Pending / Low Stock
  static const Color warningLight = Color(0xFFFFFBEB);
  
  static const Color danger = Color(0xFFEF4444); // Red / Delayed / Overbudget
  static const Color dangerLight = Color(0xFFFEF2F2);
  
  static const Color info = Color(0xFF3B82F6); // Blue - In Progress / Info
  static const Color infoLight = Color(0xFFEFF6FF);

  // Card Micro Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
