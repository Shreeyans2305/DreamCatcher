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
    const overlap = 12.0;

    final colors = [
      const Color(0xFFF97316),
      const Color(0xFF0EA5E9),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
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
                      color: colors[i % colors.length],
                      border: Border.all(color: Colors.white, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials[i],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: DesignTokens.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
