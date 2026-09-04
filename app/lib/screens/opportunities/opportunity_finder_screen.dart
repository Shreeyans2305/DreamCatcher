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
                  // Toggle Only Eligible
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
            const SizedBox(height: 10),

            // Secondary Eligibility Filter & Result Count Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${items.length} opportunities available',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => provider.setOnlyEligible(!provider.onlyEligible),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: provider.onlyEligible
                            ? DesignTokens.mintBg
                            : Colors.white,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                        border: Border.all(
                          color: provider.onlyEligible
                              ? DesignTokens.mintBorder
                              : DesignTokens.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            provider.onlyEligible
                                ? Icons.check_circle_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 16,
                            color: provider.onlyEligible
                                ? DesignTokens.mintText
                                : DesignTokens.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.filterEligibleOnly,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: provider.onlyEligible
                                  ? DesignTokens.mintText
                                  : DesignTokens.textSecondary,
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
                          onRefresh: provider.fetchOpportunities,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final opp = items[index];
                              return _buildCard(context, opp);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Opportunity opp) {
    final l10n = AppLocalizations.of(context)!;
    final elig = opp.eligibilityResult;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RoundedCard(
        onTap: () => OpportunityDetailSheet.show(context, opp),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryLight,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                  ),
                  child: Text(
                    opp.typeLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.primary,
                    ),
                  ),
                ),
                const Spacer(),
                // Eligibility badge
                if (elig != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: elig.isEligible ? DesignTokens.mintBg : DesignTokens.mustardBg,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(
                        color: elig.isEligible ? DesignTokens.mintBorder : DesignTokens.mustardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          elig.isEligible ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                          size: 14,
                          color: elig.isEligible ? DesignTokens.mintText : DesignTokens.mustardText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          elig.isEligible ? l10n.eligibleBadge : l10n.notEligibleBadge,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: elig.isEligible ? DesignTokens.mintText : DesignTokens.mustardText,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              opp.title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Benefit
            if (opp.highlightBenefit != null) ...[
              Text(
                opp.highlightBenefit!,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.primary,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Rules summary line
            if (elig != null && elig.totalRulesCount > 0) ...[
              Text(
                l10n.rulesPassed(elig.passedRulesCount, elig.totalRulesCount),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: elig.isEligible ? DesignTokens.mintText : DesignTokens.textMuted,
                  fontWeight: elig.isEligible ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ] else ...[
              Text(
                'Open to all candidates meeting basic requirements',
                style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, OpportunitiesProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.manage_search_rounded, size: 56, color: DesignTokens.textMuted),
            const SizedBox(height: 12),
            Text(
              'No matching opportunities',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try clearing your search query or disabling the "Eligible Only" filter.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                provider.setSearchQuery('');
                provider.setOnlyEligible(false);
                provider.setType('all');
              },
              child: Text(AppLocalizations.of(context)!.resetFilters),
            ),
          ],
        ),
      ),
    );
  }
}
