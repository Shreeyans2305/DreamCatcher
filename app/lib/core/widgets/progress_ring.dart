import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;
  final Widget? centerWidget;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 72.0,
    this.strokeWidth = 7.0,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentageInt = (clampedProgress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: clampedProgress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: backgroundColor ?? DesignTokens.border.withValues(alpha: 0.6),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? DesignTokens.primary,
              ),
            ),
          ),
          if (centerWidget != null)
            centerWidget!
          else if (showPercentage)
            Text(
              '$percentageInt%',
              style: GoogleFonts.poppins(
                fontSize: size * 0.26,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
