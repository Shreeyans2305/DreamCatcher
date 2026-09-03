import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/auth_user.dart';
import '../providers/auth_providers.dart';

/// Low-literacy SMS / Email OTP authentication modal flow.
/// Features high contrast, large tap targets, and plain-language guidance.
class OtpFlowView extends ConsumerStatefulWidget {
  final void Function(AuthUser user) onSuccess;

  const OtpFlowView({
    super.key,
    required this.onSuccess,
  });

  @override
  ConsumerState<OtpFlowView> createState() => _OtpFlowViewState();
}

class _OtpFlowViewState extends ConsumerState<OtpFlowView> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _identifierController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode(AppLocalizations l10n) async {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      setState(() {
        _localError = l10n.authPhoneOrEmailHint;
      });
      return;
    }

    setState(() => _localError = null);
    final success =
        await ref.read(authStateProvider.notifier).requestOtp(identifier);
    if (!success && mounted) {
      setState(() {
        _localError = ref.read(authStateProvider).errorMessage;
      });
    }
  }

  Future<void> _handleVerifyCode(AppLocalizations l10n) async {
    final otp = _otpController.text.trim();
    final authState = ref.read(authStateProvider);
    final identifier =
        authState.pendingIdentifier ?? _identifierController.text.trim();

    if (otp.length != 6) {
      setState(() {
        _localError = l10n.authInvalidCodeError;
      });
      return;
    }

    setState(() => _localError = null);
    final user = await ref
        .read(authStateProvider.notifier)
        .signInWithOtp(identifier, otp);

    if (user != null) {
      widget.onSuccess(user);
    } else if (mounted) {
      setState(() {
        _localError = l10n.authInvalidCodeError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final isOtpSent = authState.otpSent;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isOtpSent
                        ? l10n.authEnterSecurityCode
                        : l10n.authContinueOtp,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () {
                    ref.read(authStateProvider.notifier).resetOtpFlow();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            isOtpSent ? l10n.authCodeHint : l10n.authOtpSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 20),
          if (!isOtpSent) ...[
            TextField(
              key: const Key('auth_identifier_input'),
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: l10n.authEnterPhoneOrEmail,
                hintText: l10n.authPhoneOrEmailHint,
                prefixIcon: const Icon(Icons.phone_iphone_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                key: const Key('auth_send_code_button'),
                onPressed: authState.isLoading
                    ? null
                    : () => _handleSendCode(l10n),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(
                        l10n.authSendCode,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.authTestCodeHint,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('auth_otp_input'),
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: l10n.authEnterSecurityCode,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                key: const Key('auth_verify_otp_button'),
                onPressed: authState.isLoading
                    ? null
                    : () => _handleVerifyCode(l10n),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(
                        l10n.authVerifyAndSignIn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).resetOtpFlow();
                setState(() => _localError = null);
              },
              child: Text(l10n.authChangePhoneOrEmail),
            ),
          ],
          if (_localError != null) ...[
            const SizedBox(height: 12),
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
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _localError!,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 13,
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
  );
  }
}
