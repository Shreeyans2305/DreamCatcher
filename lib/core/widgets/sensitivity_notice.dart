import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// Trust & privacy card clearly explaining to rural students why
/// caste, income, or ID information is requested.
class SensitivityNotice extends StatelessWidget {
  final String? customReason;

  const SensitivityNotice({super.key, this.customReason});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA5D6A7), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFF2E7D32),
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.sensitivityNoticeTitle ?? 'Why we ask for this information',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customReason ??
                      l10n?.sensitivityNoticeBody ??
                      'This information is strictly used to match eligible scholarships and schemes. It is stored safely on your device.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2E7D32),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
