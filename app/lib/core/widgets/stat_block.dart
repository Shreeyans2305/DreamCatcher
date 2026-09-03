import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

enum StatBlockVariant { mustard, mint, lavender }

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
    this.variant = StatBlockVariant.mustard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textCol;

    switch (variant) {
      case StatBlockVariant.mustard:
        bg = DesignTokens.mustardBg;
        border = DesignTokens.mustardBorder;
        textCol = DesignTokens.mustardText;
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
    }

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        border: Border.all(color: border, width: 1.2),
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
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textCol,
                  height: 1.2,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: textCol.withValues(alpha: 0.8),
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textCol.withValues(alpha: 0.9),
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
