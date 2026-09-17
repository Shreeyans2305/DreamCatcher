import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/opportunity.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/opportunities_provider.dart';
import 'opportunity_detail_sheet.dart';

class OpportunityFinderScreen extends StatefulWidget {
  const OpportunityFinderScreen({super.key});

  @override
  State<OpportunityFinderScreen> createState() => _OpportunityFinderScreenState();
}

class _OpportunityFinderScreenState extends State<OpportunityFinderScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final provider = context.watch<OpportunitiesProvider>();
    final items = provider.filteredOpportunities;

    final typeChips = [
      FilterChipItem(label: l10n.filterAll, value: 'all'),
      FilterChipItem(label: l10n.filterScholarships, value: 'scholarship', icon: Icons.school_outlined),
      FilterChipItem(label: l10n.filterCourses, value: 'course', icon: Icons.book_outlined),
      FilterChipItem(label: l10n.filterExams, value: 'entrance_exam', icon: Icons.edit_note_rounded),
      FilterChipItem(label: l10n.filterInternships, value: 'internship', icon: Icons.work_outline_rounded),
    ];

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search Bar Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: AppSearchBar(
                controller: _searchController,
                hintText: l10n.searchHint,
                onChanged: provider.setSearchQuery,
                filterActive: provider.onlyEligible,
                onFilterTap: () {
                  provider.setOnlyEligible(!provider.onlyEligible);
                },
              ),
            ),

            // Horizontal FilterChipRow for Opportunity Type
            FilterChipRow<String>(
              items: typeChips,
              selectedValue: provider.selectedType,
              onSelected: provider.setType,
            ),
            const SizedBox(height: 12),

            // Secondary Eligibility Filter & Result Count Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.opportunitiesAvailable(items.length),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.slate600,
                    ),
                  ),
                  InkWell(
                    onTap: () => provider.setOnlyEligible(!provider.onlyEligible),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: provider.onlyEligible
                            ? DesignTokens.sageBg
                            : Colors.white,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                        border: Border.all(
                          color: provider.onlyEligible
                              ? DesignTokens.sageBorder
                              : DesignTokens.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: DesignTokens.maroon900.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            provider.onlyEligible
                                ? Icons.check_circle_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 15,
                            color: provider.onlyEligible
                                ? DesignTokens.sageText
                                : DesignTokens.textMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            l10n.filterEligibleOnly,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: provider.onlyEligible
                                  ? DesignTokens.sageText
                                  : DesignTokens.slate600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Results List
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: DesignTokens.primary),
                    )
                  : items.isEmpty
                      ? _buildEmptyState(context, provider)
                      : RefreshIndicator(
                          color: DesignTokens.primary,
                          backgroundColor: Colors.white,
                          onRefresh: provider.fetchOpportunities,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final opp = items[index];
                              return _buildCard(context, opp, langCode);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Opportunity opp, String langCode) {
    final l10n = AppLocalizations.of(context)!;
    final elig = opp.eligibilityResult;
    final localizedTitle = opp.getLocalizedTitle(langCode);
    final localizedBenefit = opp.getLocalizedHighlightBenefit(l10n, langCode) ?? opp.highlightBenefit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RoundedCard(
        onTap: () => OpportunityDetailSheet.show(context, opp),
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Type badge (Blush pill)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DesignTokens.blushBg,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                    border: Border.all(color: DesignTokens.blushBorder),
                  ),
                  child: Text(
                    opp.getLocalizedTypeLabel(l10n),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.maroon900,
                    ),
                  ),
                ),
                const Spacer(),
                // Eligibility badge (Sage green)
                if (elig != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: elig.isEligible ? DesignTokens.sageBg : DesignTokens.mustardBg,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(
                        color: elig.isEligible ? DesignTokens.sageBorder : DesignTokens.mustardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          elig.isEligible ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                          size: 13,
                          color: elig.isEligible ? DesignTokens.sageText : DesignTokens.mustardText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          elig.isEligible ? l10n.eligibleBadge : l10n.notEligibleBadge,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: elig.isEligible ? DesignTokens.sageText : DesignTokens.mustardText,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              localizedTitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Benefit
            if (localizedBenefit != null && localizedBenefit.isNotEmpty) ...[
              Text(
                localizedBenefit,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.maroon900.withValues(alpha: 0.85),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
            ],

            // Rules summary / footer line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (elig != null && elig.totalRulesCount > 0)
                  Text(
                    l10n.rulesPassed(elig.passedRulesCount, elig.totalRulesCount),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: elig.isEligible ? DesignTokens.sageText : DesignTokens.slate600,
                      fontWeight: elig.isEligible ? FontWeight.w600 : FontWeight.normal,
                    ),
                  )
                else
                  Text(
                    l10n.openToAllCriteria,
                    style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.slate600),
                  ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: DesignTokens.cream50,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: DesignTokens.maroon900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, OpportunitiesProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.manage_search_rounded, size: 52, color: DesignTokens.textMuted),
            const SizedBox(height: 12),
            Text(
              l10n.noMatchingOpportunities,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noMatchingOpportunitiesSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                provider.setSearchQuery('');
                provider.setOnlyEligible(false);
                provider.setType('all');
              },
              child: Text(l10n.resetFilters),
            ),
          ],
        ),
      ),
    );
  }
}
