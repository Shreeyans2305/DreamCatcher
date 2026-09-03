import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/offline_state_view.dart';
import '../../../core/widgets/sensitivity_notice.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(studentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => OfflineStateView(
          message: err.toString(),
          onRetry: () => ref.read(studentProfileProvider.notifier).loadProfile(),
        ),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          profile.name.isNotEmpty ? profile.name[0] : 'S',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.district}, ${profile.state} • ${profile.age} yrs',
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sensitivity notice banner
              const SensitivityNotice(),
              const SizedBox(height: 12),

              // Academic Details
              _buildSectionCard(
                context,
                title: l10n.profileCurriculum,
                icon: Icons.school_outlined,
                content: Text(profile.curriculum, style: const TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 12),

              // Demographic & Eligibility Details
              _buildSectionCard(
                context,
                title: '${l10n.profileCaste} & ${l10n.profileIncome}',
                icon: Icons.account_balance_outlined,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.profileCaste}: ${profile.casteCategory}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.profileIncome}: ${profile.incomeBracket}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Skills & Subjects
              _buildSectionCard(
                context,
                title: l10n.profileSkills,
                icon: Icons.lightbulb_outline,
                content: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.map((skill) => Chip(label: Text(skill))).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Aspirations
              _buildSectionCard(
                context,
                title: l10n.profileAspirations,
                icon: Icons.stars_outlined,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: profile.aspirations
                      .map(
                        (asp) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.arrow_right_rounded, size: 22, color: Colors.blue),
                              Expanded(child: Text(asp, style: const TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            content,
          ],
        ),
      ),
    );
  }
}
