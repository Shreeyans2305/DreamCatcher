import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sensitivity_notice.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepReview extends ConsumerWidget {
  final void Function(int step) onGoToStep;
  final VoidCallback onSubmit;

  const StepReview({
    super.key,
    required this.onGoToStep,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingStateProvider);
    final draft = onboardingState.draft;
    final simState = ref.watch(networkSimulatorProvider);
    final isOffline = simState.simulateFailure;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.reviewTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.reviewSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Connectivity Notice banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOffline ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isOffline ? const Color(0xFFFFB74D) : const Color(0xFFA5D6A7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isOffline
                      ? Icons.signal_cellular_connected_no_internet_4_bar_rounded
                      : Icons.wifi_rounded,
                  color: isOffline ? AppTheme.secondaryAmber : AppTheme.accentGreen,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isOffline ? l10n.reviewOfflineNotice : l10n.reviewOnlineNotice,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isOffline ? const Color(0xFFE65100) : const Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Basic Info Card
          _buildReviewCard(
            context: context,
            title: l10n.reviewBasicInfo,
            icon: Icons.person_outline_rounded,
            stepIndex: 0,
            editLabel: l10n.btnEdit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldRow(l10n.fieldName, draft.name.isNotEmpty ? draft.name : '—'),
                _buildFieldRow(l10n.fieldAge, '${draft.age} years old'),
                _buildFieldRow(l10n.fieldGender, draft.gender.isNotEmpty ? draft.gender : '—'),
                _buildFieldRow(l10n.profileLocation, '${draft.district}, ${draft.state}'),
                _buildFieldRow(
                  l10n.fieldLanguage,
                  draft.preferredLanguage == 'hi' ? 'हिंदी (Hindi)' : 'English',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Family & Economic Context Card
          _buildReviewCard(
            context: context,
            title: l10n.reviewEconomic,
            icon: Icons.family_restroom_rounded,
            stepIndex: 1,
            editLabel: l10n.btnEdit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldRow(
                  l10n.fieldIncomeBracket,
                  draft.incomeBracket.isNotEmpty ? draft.incomeBracket : '—',
                ),
                _buildFieldRow(
                  l10n.fieldCasteCategory,
                  draft.casteCategory.isNotEmpty ? draft.casteCategory : '—',
                ),
                _buildFieldRow(
                  l10n.fieldFirstGenLearner,
                  draft.isFirstGenLearner ? l10n.firstGenYes : l10n.firstGenNo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Academic Background Card
          _buildReviewCard(
            context: context,
            title: l10n.reviewAcademic,
            icon: Icons.school_outlined,
            stepIndex: 2,
            editLabel: l10n.btnEdit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldRow(
                  l10n.profileCurriculum,
                  draft.hasFormalCurriculum
                      ? '${draft.board} • ${draft.grade}${draft.marks.isNotEmpty ? " (${draft.marks})" : ""}'
                      : l10n.academicModeUnstructured,
                ),
                if (draft.unstructuredLearning.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.unstructuredLearningPrompt}:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    draft.unstructuredLearning,
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
                if (draft.practicalSubjects.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: draft.practicalSubjects
                        .map((s) => Chip(
                              label: Text(s, style: const TextStyle(fontSize: 12)),
                              padding: EdgeInsets.zero,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Skills & Interests Card
          _buildReviewCard(
            context: context,
            title: l10n.reviewSkills,
            icon: Icons.lightbulb_outline_rounded,
            stepIndex: 3,
            editLabel: l10n.btnEdit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (draft.skills.isNotEmpty || draft.customSkills.isNotEmpty) ...[
                  Text('${l10n.skillsTitle}:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...draft.skills
                          .where((s) => !draft.customSkills.contains(s))
                          .map((s) => Chip(label: Text(s, style: const TextStyle(fontSize: 12)))),
                      ...draft.customSkills.map((s) => Chip(
                            avatar: const Icon(Icons.star, size: 14, color: AppTheme.secondaryAmber),
                            label: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          )),
                    ],

                  ),
                  const SizedBox(height: 8),
                ],
                if (draft.interests.isNotEmpty) ...[
                  Text('${l10n.interestsTitle}:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: draft.interests
                        .map((i) => Chip(label: Text(i, style: const TextStyle(fontSize: 12))))
                        .toList(),
                  ),
                ],
                if (draft.freeTextInterests.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    draft.freeTextInterests,
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. Aspirations Card
          _buildReviewCard(
            context: context,
            title: l10n.reviewAspirations,
            icon: Icons.stars_rounded,
            stepIndex: 4,
            editLabel: l10n.btnEdit,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (draft.aspirationText.isNotEmpty)
                  Text(
                    draft.aspirationText,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )
                else
                  const Text('—', style: TextStyle(fontSize: 14)),
                if (draft.selectedAspirationPrompts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: draft.selectedAspirationPrompts
                        .map((p) => Chip(
                              backgroundColor: AppTheme.secondaryContainer,
                              label: Text(p, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryAmber)),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Privacy reminder
          const SensitivityNotice(),
          const SizedBox(height: 20),

          // Submit button
          ElevatedButton(
            key: const Key('onboarding_submit_button'),
            onPressed: onboardingState.isSubmitting ? null : onSubmit,
            child: onboardingState.isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Saving Profile...'),
                    ],
                  )
                : Text(l10n.btnSubmitProfile),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int stepIndex,
    required String editLabel,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, size: 20, color: AppTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  key: Key('edit_step_${stepIndex + 1}_button'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(48, 36),
                  ),
                  onPressed: () => onGoToStep(stepIndex),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(editLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 16),
            content,
          ],

        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
