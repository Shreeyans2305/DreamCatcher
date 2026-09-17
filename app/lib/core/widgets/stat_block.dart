import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

enum StatBlockVariant { blush, mint, lavender, mustard, sage }

class StatBlock extends StatelessWidget {
  final String stat;
  final String label;
  final IconData? icon;
  final StatBlockVariant variant;
  final VoidCallback? onTap;

  const StatBlock({
    super.key,
    required this.stat,
    required this.label,
    this.icon,
    this.variant = StatBlockVariant.blush,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textCol;

    switch (variant) {
      case StatBlockVariant.blush:
        bg = DesignTokens.blushBg;
        border = DesignTokens.blushBorder;
        textCol = DesignTokens.blushText;
        break;
      case StatBlockVariant.mint:
        bg = DesignTokens.mintBg;
        border = DesignTokens.mintBorder;
        textCol = DesignTokens.mintText;
        break;
      case StatBlockVariant.lavender:
        bg = DesignTokens.lavenderBg;
        border = DesignTokens.lavenderBorder;
        textCol = DesignTokens.lavenderText;
        break;
      case StatBlockVariant.sage:
        bg = DesignTokens.sageBg;
        border = DesignTokens.sageBorder;
        textCol = DesignTokens.sageText;
        break;
      case StatBlockVariant.mustard:
        bg = DesignTokens.mustardBg;
        border = DesignTokens.mustardBorder;
        textCol = DesignTokens.mustardText;
        break;
    }

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.maroon900.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat,
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textCol,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: textCol.withValues(alpha: 0.75),
                  size: 22,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textCol.withValues(alpha: 0.85),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
          child: content,
        ),
      );
    }

    return content;
  }
}
