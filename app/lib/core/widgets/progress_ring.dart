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
    this.strokeWidth = 6.0,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: clampedProgress),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          final percentageInt = (animatedValue * 100).round();

          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: animatedValue,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  backgroundColor: backgroundColor ?? DesignTokens.blush200,
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
                  style: GoogleFonts.inter(
                    fontSize: size * 0.26,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
