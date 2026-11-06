import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary
  static const Color primary = Color(0xFF0F172A); // Deep Slate Navy
  static const Color primaryLight = Color(0xFF1E293B);
  static const Color accent = Color(0xFF2563EB); // Industrial Blue
  static const Color amber = Color(0xFFF59E0B); // Warehouse Amber

  // Background & Surfaces
  static const Color background = Color(0xFFF1F5F9); // Crisp slate surface
  static const Color backgroundDark = Color(0xFF0B1120);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFCBD5E1);

  // Glassmorphism Palette
  static const Color glassSurface = Color(0xCCFFFFFF); // 80% opacity white
  static const Color glassSurfaceSubtle = Color(0x99FFFFFF); // 60% opacity white
  static const Color glassSurfaceLight = Color(0x66FFFFFF); // 40% opacity white
  static const Color glassBorder = Color(0x99FFFFFF); // Frosted reflection border
  static const Color glassBorderSubtle = Color(0x4DFFFFFF); // 30% border
  static const Color glassShadow = Color(0x140F172A); // Soft atmospheric shadow

  // Ambient Gradient Orbs
  static const Color ambientIndigo = Color(0xFF6366F1);
  static const Color ambientCyan = Color(0xFF0EA5E9);
  static const Color ambientAmber = Color(0xFFF59E0B);
  static const Color ambientPurple = Color(0xFF8B5CF6);
  static const Color ambientRose = Color(0xFFF43F5E);

  // Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFFFFFFF);

  // Statuses
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Helper for Stock Status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
      case 'in_stock':
      case 'active':
        return success;
      case 'low stock':
      case 'low_stock':
        return warning;
      case 'out of stock':
      case 'out_of_stock':
      case 'empty':
        return danger;
      default:
        return textSecondary;
    }
  }

  static Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
      case 'in_stock':
      case 'active':
        return successLight;
      case 'low stock':
      case 'low_stock':
        return warningLight;
      case 'out of stock':
      case 'out_of_stock':
      case 'empty':
        return dangerLight;
      default:
        return surfaceVariant;
    }
  }
}
