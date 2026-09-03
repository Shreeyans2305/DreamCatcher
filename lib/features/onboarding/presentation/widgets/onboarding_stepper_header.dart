import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Accessible, visual step indicator designed for low-digital literacy students.
/// Features high contrast, numbered circles, and clear step labels.
class OnboardingStepperHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final void Function(int step) onStepTapped;

  const OnboardingStepperHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
    required this.onStepTapped,
  });

  String _getStepName(BuildContext context, int step) {
    final l10n = AppLocalizations.of(context)!;
    switch (step) {
      case 0:
        return l10n.stepBasicInfo;
      case 1:
        return l10n.stepFamilyContext;
      case 2:
        return l10n.stepAcademic;
      case 3:
        return l10n.stepSkillsInterests;
      case 4:
        return l10n.stepAspirations;
      case 5:
        return l10n.stepReview;
      default:
        return '';
    }
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.person_outline_rounded;
      case 1:
        return Icons.family_restroom_rounded;
      case 2:
        return Icons.school_outlined;
      case 3:
        return Icons.lightbulb_outline_rounded;
      case 4:
        return Icons.stars_rounded;
      case 5:
        return Icons.fact_check_outlined;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Counter & Current Step Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.onboardingStep(currentStep + 1, totalSteps),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.cloud_done_outlined, size: 16, color: AppTheme.accentGreen),
                  const SizedBox(width: 4),
                  Text(
                    l10n.btnSavedDraftNotice,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _getStepName(context, currentStep),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal step icons with connecting lines
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: index <= currentStep ? () => onStepTapped(index) : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? AppTheme.primaryBlue
                                  : isCompleted
                                      ? AppTheme.accentGreen
                                      : Colors.grey[200],
                              border: Border.all(
                                color: isCurrent
                                    ? AppTheme.primaryBlue
                                    : isCompleted
                                        ? AppTheme.accentGreen
                                        : Colors.grey[350]!,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                                  : Icon(
                                      _getStepIcon(index),
                                      size: 18,
                                      color: isCurrent ? Colors.white : Colors.grey[600],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 3,
                          color: isCompleted ? AppTheme.accentGreen : Colors.grey[300],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
