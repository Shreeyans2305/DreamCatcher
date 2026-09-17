import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double borderRadius;

  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.borderRadius = DesignTokens.radiusCard,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignTokens.cardSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? DesignTokens.border.withValues(alpha: 0.7),
          width: 1.0,
        ),
        boxShadow: DesignTokens.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: DesignTokens.maroon900.withValues(alpha: 0.06),
          highlightColor: DesignTokens.maroon900.withValues(alpha: 0.03),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
