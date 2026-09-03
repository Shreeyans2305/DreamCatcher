import 'package:flutter/material.dart';

class DesignTokens {
  // Brand & Accent Colors
  static const Color primary = Color(0xFFE05A2B); // Warm Saffron / Terracotta
  static const Color primaryDark = Color(0xFFC0481E);
  static const Color primaryLight = Color(0xFFFDEEE9);
  
  // Background & Surfaces
  static const Color background = Color(0xFFF5F6FA); // Soft off-white
  static const Color cardSurface = Colors.white;
  static const Color navDarkSurface = Color(0xFF1A1A1A); // Reserved for bottom nav
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF6B7280);
  
  // Secondary Accent Blocks (Pastel Cards)
  static const Color mustardBg = Color(0xFFFFF7DB);
  static const Color mustardBorder = Color(0xFFF3DF9A);
  static const Color mustardText = Color(0xFF7A5900);
  
  static const Color mintBg = Color(0xFFE3F7EE);
  static const Color mintBorder = Color(0xFFA3E7C6);
  static const Color mintText = Color(0xFF0F6B45);
  
  static const Color lavenderBg = Color(0xFFF0ECFE);
  static const Color lavenderBorder = Color(0xFFD3C6F7);
  static const Color lavenderText = Color(0xFF4F378B);

  // Border & Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color inputBorder = Color(0xFFD1D5DB);
  
  // Border Radii
  static const double radiusCard = 22.0;
  static const double radiusPill = 999.0;
  static const double radiusInput = 16.0;
  static const double radiusSmall = 10.0;

  // Touch Target Minimum
  static const double minTouchTarget = 48.0;
  
  // Elevation Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}
