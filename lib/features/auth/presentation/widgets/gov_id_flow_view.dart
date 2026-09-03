import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/auth_user.dart';
import '../providers/auth_providers.dart';

/// Multi-step Government ID verification modal flow (Aadhaar / Student ID style).
/// Step 1: Explicit consent explaining why ID is needed.
/// Step 2: 12-digit ID entry with validation.
/// Step 3: Verification step backed by GovIdRepository.
class GovIdFlowView extends ConsumerStatefulWidget {
  final void Function(AuthUser user) onSuccess;

  const GovIdFlowView({
    super.key,
    required this.onSuccess,
  });

  @override
  ConsumerState<GovIdFlowView> createState() => _GovIdFlowViewState();
}

class _GovIdFlowViewState extends ConsumerState<GovIdFlowView> {
  int _currentStep = 0; // 0: Consent, 1: ID Entry
  bool _consentChecked = false;
  final TextEditingController _idController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify(AppLocalizations l10n) async {
    final rawId = _idController.text.replaceAll(RegExp(r'\s+|-'), '');
    if (rawId.length != 12) {
      setState(() {
        _errorMessage = l10n.authGovIdInvalid;
      });
      return;
    }

    setState(() => _errorMessage = null);

    final result = await ref.read(authStateProvider.notifier).verifyGovId(
          idNumber: rawId,
          consentGiven: _consentChecked,
        );

    if (result.isSuccess) {
      final user = ref.read(authStateProvider).user;
      if (user != null) {
        widget.onSuccess(user);
      }
    } else if (mounted) {
      setState(() {
        _errorMessage = result.message ?? l10n.authGovIdInvalid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);

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
                    l10n.authContinueGovId,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          const SizedBox(height: 12),

          // STEP 1: Consent Screen
          if (_currentStep == 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          color: Colors.amber.shade900, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.authGovIdConsentTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authGovIdConsentBody,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown.shade900,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              key: const Key('auth_gov_id_consent_checkbox'),
              value: _consentChecked,
              onChanged: (val) {
                setState(() {
                  _consentChecked = val ?? false;
                  _errorMessage = null;
                });
              },
              title: Text(
                l10n.authGovIdConsentCheckbox,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                key: const Key('auth_gov_id_continue_button'),
                onPressed: _consentChecked
                    ? () {
                        setState(() {
                          _currentStep = 1;
                          _errorMessage = null;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.actionContinue,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]

          // STEP 2: ID Number Entry & Verification Step
          else ...[
            Text(
              l10n.authEnterGovId,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('auth_gov_id_input'),
              controller: _idController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: l10n.authGovIdHint,
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (authState.isLoading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        l10n.authGovIdVerifying,
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: 56,
              child: ElevatedButton(
                key: const Key('auth_gov_id_verify_button'),
                onPressed: authState.isLoading ? null : () => _handleVerify(l10n),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.authVerifyAndSignIn,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                  _errorMessage = null;
                });
              },
              child: const Text('Back to Consent'),
            ),
          ],

          if (_errorMessage != null) ...[
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
                      _errorMessage!,
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
