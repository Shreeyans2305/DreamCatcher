import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// Explicit offline or connection error view.
/// Avoids infinite spinners and gives clear feedback + retry option to users.
class OfflineStateView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool isBannerOnly;

  const OfflineStateView({
    super.key,
    this.message,
    this.onRetry,
    this.isBannerOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (isBannerOnly) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFFFF3E0),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded, color: Color(0xFFE65100), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message ?? l10n?.offlineMessage ?? 'Viewing cached offline data.',
                style: const TextStyle(fontSize: 13, color: Color(0xFFE65100), fontWeight: FontWeight.w500),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(l10n?.actionRetry ?? 'Retry'),
              ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                size: 56,
                color: Color(0xFFC62828),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n?.networkErrorTitle ?? 'Connection Interrupted',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message ?? l10n?.networkErrorMessage ?? 'Unable to connect right now. Using locally stored data.',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF616161),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (onRetry != null)
              SizedBox(
                width: 220,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    l10n?.actionRetry ?? 'Retry',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
