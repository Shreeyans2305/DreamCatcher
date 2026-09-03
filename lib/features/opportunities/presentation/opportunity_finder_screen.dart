import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/offline_state_view.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/opportunity.dart';
import 'providers/opportunity_providers.dart';

class OpportunityFinderScreen extends ConsumerWidget {
  const OpportunityFinderScreen({super.key});

  String _getCategoryLabel(OpportunityCategory category, AppLocalizations l10n) {
    switch (category) {
      case OpportunityCategory.careerPathway:
        return l10n.categoryPathways;
      case OpportunityCategory.scholarship:
        return l10n.categoryScholarships;
      case OpportunityCategory.entranceExam:
        return l10n.categoryExams;
      case OpportunityCategory.course:
        return l10n.categoryCourses;
      case OpportunityCategory.internship:
        return l10n.categoryInternships;
      case OpportunityCategory.higherEd:
        return l10n.categoryHigherEd;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(opportunitiesProvider);
    final selectedCategory = ref.watch(selectedOpportunityCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.opportunitiesTitle),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(l10n.categoryAll),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(selectedOpportunityCategoryProvider.notifier).state = null;
                      ref.read(opportunitiesProvider.notifier).loadOpportunities();
                    }
                  },
                ),
                const SizedBox(width: 8),
                ...OpportunityCategory.values.map((cat) {
                  final label = _getCategoryLabel(cat, l10n);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: selectedCategory == cat,
                      onSelected: (selected) {
                        ref.read(selectedOpportunityCategoryProvider.notifier).state =
                            selected ? cat : null;
                        ref.read(opportunitiesProvider.notifier).loadOpportunities();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => OfflineStateView(
                message: err.toString(),
                onRetry: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
              ),
              data: (data) {
                final list = data.opportunities;

                return Column(
                  children: [
                    if (data.isFromOfflineCache)
                      OfflineStateView(
                        isBannerOnly: true,
                        message: l10n.offlineMessage,
                        onRetry: () =>
                            ref.read(opportunitiesProvider.notifier).loadOpportunities(),
                      ),
                    Expanded(
                      child: list.isEmpty
                          ? Center(
                              child: Text(
                                l10n.categoryAll,
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final opp = list[index];
                                return _buildOpportunityCard(context, opp, l10n);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(
    BuildContext context,
    Opportunity opp,
    AppLocalizations l10n,
  ) {
    final catLabel = _getCategoryLabel(opp.category, l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    catLabel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (opp.deadline != null)
                  Row(
                    children: [
                      const Icon(Icons.alarm, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        opp.deadline!,
                        style: const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              opp.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.providerLabel}: ${opp.provider}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              opp.description,
              style: const TextStyle(fontSize: 14, height: 1.35),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.eligibilityLabel}: ${opp.eligibility}',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
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
