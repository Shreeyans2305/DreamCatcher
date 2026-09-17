import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

class AvatarStack extends StatelessWidget {
  final String label;
  final List<String> initials;
  final int totalCount;

  const AvatarStack({
    super.key,
    required this.label,
    this.initials = const ['AS', 'PK', 'RV', 'MN'],
    this.totalCount = 18,
  });

  @override
  Widget build(BuildContext context) {
    const avatarSize = 34.0;
    const overlap = 10.0;

    final avatarThemes = [
      (bg: DesignTokens.blush200, text: DesignTokens.maroon900),
      (bg: DesignTokens.success, text: Colors.white),
      (bg: DesignTokens.accentLav, text: DesignTokens.maroon900),
      (bg: DesignTokens.accentMint, text: DesignTokens.maroon900),
      (bg: DesignTokens.maroon900, text: Colors.white),
    ];

    return Row(
      children: [
        SizedBox(
          width: (initials.length * (avatarSize - overlap)) + overlap,
          height: avatarSize,
          child: Stack(
            children: [
              for (int i = 0; i < initials.length; i++)
                Positioned(
                  left: i * (avatarSize - overlap),
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarThemes[i % avatarThemes.length].bg,
                      border: Border.all(color: Colors.white, width: 2.2),
                      boxShadow: [
                        BoxShadow(
                          color: DesignTokens.maroon900.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials[i],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: avatarThemes[i % avatarThemes.length].text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: DesignTokens.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
