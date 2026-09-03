import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'providers/onboarding_providers.dart';
import 'widgets/onboarding_stepper_header.dart';
import 'widgets/step_academic_background.dart';
import 'widgets/step_aspirations.dart';
import 'widgets/step_basic_info.dart';
import 'widgets/step_economic_context.dart';
import 'widgets/step_review.dart';
import 'widgets/step_skills_interests.dart';

/// The primary onboarding wizard screen designed for rural Indian students.
/// Implements a 6-step accessible stepper, automatic Drift SQLite draft saving
/// on every step transition, sensitive field explanations, and offline sync queueing.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  void _handleNextStep(int currentStep) {
    if (currentStep < 5) {
      ref.read(onboardingStateProvider.notifier).setStep(currentStep + 1);
    }
  }

  void _handlePreviousStep(int currentStep) {
    if (currentStep > 0) {
      ref.read(onboardingStateProvider.notifier).setStep(currentStep - 1);
    }
  }


  Future<void> _handleSubmitProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref.read(onboardingStateProvider.notifier).submitProfile();

    if (!mounted) return;

    if (result != null) {
      final message = result.isPendingSync
          ? l10n.profileQueuedOfflineSuccess
          : l10n.profileSubmittedSuccess;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 15)),
          backgroundColor: result.isPendingSync ? AppTheme.secondaryAmber : AppTheme.accentGreen,
          duration: const Duration(seconds: 4),
        ),
      );

      // Navigate to Home
      context.go('/home');
    } else {
      final err = ref.read(onboardingStateProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err ?? 'Error saving profile. Please retry.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingStateProvider);
    final currentStep = onboardingState.currentStep;
    final simState = ref.watch(networkSimulatorProvider);
    final isOffline = simState.simulateFailure;

    return Scaffold(

      appBar: AppBar(
        title: Text(l10n.profileTitle),
        elevation: 1,
        actions: [
          if (isOffline)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_off, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(l10n.offlineTitle, style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome Header banner on Step 0 for rural student motivation
            if (currentStep == 0)
              Container(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.explore_rounded, color: AppTheme.primaryBlue, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.onboardingWelcome,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          Text(
                            l10n.onboardingDescription,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Stepper progress indicator
            OnboardingStepperHeader(
              currentStep: currentStep,
              totalSteps: 6,
              onStepTapped: (step) => ref.read(onboardingStateProvider.notifier).setStep(step),
            ),
            const Divider(height: 1, thickness: 1),

            // Active step content
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: [
                  const StepBasicInfo(),
                  const StepEconomicContext(),
                  const StepAcademicBackground(),
                  const StepSkillsInterests(),
                  const StepAspirations(),
                  StepReview(
                    onGoToStep: (step) => ref.read(onboardingStateProvider.notifier).setStep(step),
                    onSubmit: _handleSubmitProfile,
                  ),
                ],
              ),
            ),

            // Bottom Navigation Controls (Steps 0 through 4)
            if (currentStep < 5)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (currentStep > 0) ...[
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          key: const Key('onboarding_back_button'),
                          onPressed: () => _handlePreviousStep(currentStep),
                          child: Text(l10n.btnBack),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        key: const Key('onboarding_next_button'),
                        onPressed: () => _handleNextStep(currentStep),
                        child: Text(
                          currentStep == 0 ? l10n.onboardingGetStarted : l10n.btnNext,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
