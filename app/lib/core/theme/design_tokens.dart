import 'package:flutter/material.dart';

class DesignTokens {
  // Brand & Core Palette Tokens
  static const Color maroon900 = Color(0xFF3D2327); // Deep wine / near-black — primary brand
  static const Color slate600 = Color(0xFF55585E);  // Secondary text, muted icons, unselected state
  static const Color blush200 = Color(0xFFE9D3C6);  // Accent surface — stat cards, highlight chips
  static const Color cream50 = Color(0xFFF4EAE0);   // App background
  static const Color white = Color(0xFFFFFFFF);     // Card surfaces

  // Aliases for core themes
  static const Color primary = maroon900;
  static const Color primaryDark = Color(0xFF261417);
  static const Color primaryLight = blush200;
  static const Color background = cream50;
  static const Color cardSurface = white;
  static const Color navDarkSurface = maroon900;

  // Text Colors
  static const Color textPrimary = maroon900;
  static const Color textSecondary = slate600;
  static const Color textMuted = Color(0xFF7E7D82);

  // Supporting Semantic Colors (Muted / Dusty)
  static const Color success = Color(0xFF7FA88B);    // Eligible / positive status, muted sage green
  static const Color error = Color(0xFFC84B4B);      // Destructive / error status
  static const Color accentLav = Color(0xFFC9BFE0);   // Secondary highlight cards / AI guide
  static const Color accentMint = Color(0xFFB9D9C7);  // Tertiary highlight cards
  static const Color warnYellow = Color(0xFFEAD9A6);  // Progress / attention / warning cards

  // Tinted Card Surfaces & Variants
  // Blush (Completeness / Stats)
  static const Color blushBg = Color(0xFFF9F1EC);
  static const Color blushBorder = Color(0xFFE9D3C6);
  static const Color blushText = Color(0xFF3D2327);

  // Mint (Matched Opportunities / Success)
  static const Color mintBg = Color(0xFFEDF6F1);
  static const Color mintBorder = Color(0xFFB9D9C7);
  static const Color mintText = Color(0xFF26503B);

  // Lavender (AI Career Guide / Interests)
  static const Color lavenderBg = Color(0xFFF3F0F9);
  static const Color lavenderBorder = Color(0xFFC9BFE0);
  static const Color lavenderText = Color(0xFF453664);

  // Sage (Eligible Badges / Positive Aid)
  static const Color sageBg = Color(0xFFEEF5F0);
  static const Color sageBorder = Color(0xFF7FA88B);
  static const Color sageText = Color(0xFF2C5539);

  // Yellow / Mustard (Review / Attention)
  static const Color mustardBg = Color(0xFFFAF5E8);
  static const Color mustardBorder = Color(0xFFEAD9A6);
  static const Color mustardText = Color(0xFF63521E);

  // Border & Dividers
  static const Color border = Color(0xFFE8DFD8);
  static const Color inputBorder = Color(0xFFDDD3CB);

  // Border Radii (Large & consistent: 20-24px on cards, 999px on pills)
  static const double radiusCard = 22.0;
  static const double radiusPill = 999.0;
  static const double radiusInput = 18.0;
  static const double radiusSmall = 12.0;

  // Touch Target Minimum
  static const double minTouchTarget = 48.0;

  // Elevation Shadows (Soft low-opacity shadow, warm tint)
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF3D2327).withValues(alpha: 0.05),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF3D2327).withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}
