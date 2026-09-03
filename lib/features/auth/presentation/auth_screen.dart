import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/network_providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/auth_user.dart';
import 'providers/auth_providers.dart';
import 'widgets/gov_id_flow_view.dart';
import 'widgets/otp_flow_view.dart';

/// Primary authentication screen designed for rural Indian students.
/// Features low digital literacy accommodations: large touch targets (>= 56px),
/// plain language without jargon, audio hint button, and clear entry paths.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isPlayingVoiceHint = false;

  void _handleAuthSuccess(AuthUser user) {
    if (!mounted) return;
    if (user.isProfileComplete) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  void _showOtpModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OtpFlowView(
        onSuccess: (user) {
          Navigator.of(context).pop();
          _handleAuthSuccess(user);
        },
      ),
    );
  }

  void _showGovIdModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => GovIdFlowView(
        onSuccess: (user) {
          Navigator.of(context).pop();
          _handleAuthSuccess(user);
        },
      ),
    );
  }

  void _playVoiceHint(BuildContext context, AppLocalizations l10n) {
    setState(() => _isPlayingVoiceHint = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔊 ${l10n.authWelcomeSubtitle}',
          style: const TextStyle(fontSize: 15),
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isPlayingVoiceHint = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final simState = ref.watch(networkSimulatorProvider);
    final isOffline = simState.simulateFailure || authState.isOffline;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.navAuth,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: l10n.authVoiceHint,
            icon: Icon(
              _isPlayingVoiceHint
                  ? Icons.volume_up_rounded
                  : Icons.volume_up_outlined,
              color: _isPlayingVoiceHint
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () => _playVoiceHint(context, l10n),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Offline connectivity banner if device is currently disconnected
              if (isOffline) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade400),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          color: Colors.amber.shade900, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.authOfflineNotice,
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),
              // App Logo / Welcome Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: 44,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title and Subtitle with clear, accessible typography
              Text(
                l10n.authWelcomeTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authWelcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // PATH 1: Continue with Google
              SizedBox(
                height: 58,
                child: ElevatedButton.icon(
                  key: const Key('auth_google_button'),
                  icon: Image.network(
                    'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_circle,
                      size: 26,
                      color: Colors.redAccent,
                    ),
                  ),
                  label: authState.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(
                          l10n.authContinueGoogle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 1,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final user = await ref
                              .read(authStateProvider.notifier)
                              .signInWithGoogle();
                          if (user != null) {
                            _handleAuthSuccess(user);
                          }
                        },
                ),
              ),

              const SizedBox(height: 18),

              // PATH 2: Continue with Mobile / Email OTP
              SizedBox(
                height: 58,
                child: OutlinedButton.icon(
                  key: const Key('auth_otp_button'),
                  icon: Icon(
                    Icons.phone_android_rounded,
                    size: 26,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    l10n.authContinueOtp,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showOtpModal(context),
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      l10n.authOrDivider,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 24),

              // PATH 3: Verify with Government ID (Aadhaar-style)
              SizedBox(
                height: 58,
                child: OutlinedButton.icon(
                  key: const Key('auth_gov_id_button'),
                  icon: const Icon(
                    Icons.badge_outlined,
                    size: 26,
                    color: Colors.teal,
                  ),
                  label: Text(
                    l10n.authContinueGovId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.teal, width: 1.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showGovIdModal(context),
                ),
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authState.errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
