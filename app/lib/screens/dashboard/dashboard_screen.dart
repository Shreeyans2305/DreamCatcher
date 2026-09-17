import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/opportunity.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunities_provider.dart';
import '../opportunities/opportunity_detail_sheet.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToOpportunities;
  final VoidCallback onNavigateToChat;
  final VoidCallback onNavigateToProfile;

  const DashboardScreen({
    super.key,
    required this.onNavigateToOpportunities,
    required this.onNavigateToChat,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final opps = context.watch<OpportunitiesProvider>();
    final student = auth.currentStudent;
    final langCode = Localizations.localeOf(context).languageCode;

    final name = student?.name.split(' ').first ?? 'Friend';
    final completenessPercent = student?.completenessPercentage ?? 0;
    final matchedCount = opps.totalMatchedCount;
    final region = student?.location?.district ?? student?.location?.state ?? 'your area';

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: DesignTokens.primary,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.wait([
              auth.refreshProfile(),
              opps.fetchOpportunities(),
            ]);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Greeting Header Pattern
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.greeting(name),
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: DesignTokens.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.tagline,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: DesignTokens.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Profile Avatar
                    StudentAvatar(
                      avatarUrl: auth.avatarUrl,
                      name: student?.name ?? 'Friend',
                      size: 48,
                      onTap: onNavigateToProfile,
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // 2-Column Stat Card Grid (Profile Completeness & Matched Opportunities)
                Row(
                  children: [
                    Expanded(
                      child: StatBlock(
                        stat: '$completenessPercent%',
                        label: l10n.dashboardCompleteness,
                        variant: StatBlockVariant.blush,
                        icon: Icons.pie_chart_outline_rounded,
                        onTap: onNavigateToProfile,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: StatBlock(
                        stat: '$matchedCount',
                        label: l10n.dashboardMatchedOpps,
                        variant: StatBlockVariant.mint,
                        icon: Icons.star_outline_rounded,
                        onTap: onNavigateToOpportunities,
                      ),
                    ),
                  ],
                ),

                // Profile Completion Action Banner (If profile < 100%)
                if (student != null && student.missingSteps.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: onNavigateToProfile,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DesignTokens.mustardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: DesignTokens.mustardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: DesignTokens.warnYellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.checklist_rtl_rounded, size: 17, color: DesignTokens.mustardText),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next to 100%: ${student.missingSteps.first.title}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: DesignTokens.mustardText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${student.missingSteps.length} missing items • Tap to complete & boost matches',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: DesignTokens.mustardText.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 20, color: DesignTokens.mustardText),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Matched Opportunities Summary Row (White Card with Soft Shadow)
                RoundedCard(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  backgroundColor: Colors.white,
                  child: AvatarStack(
                    label: matchedCount > 0
                        ? '${l10n.dashboardMatchedOpps}: $matchedCount ($region)'
                        : '${l10n.viewAll}: $region',
                    totalCount: matchedCount > 0 ? matchedCount : opps.allOpportunities.length,
                  ),
                ),
                const SizedBox(height: 16),

                // AI Career Guide Highlight / Progress Banner (Tinted Card)
                RoundedCard(
                  padding: const EdgeInsets.all(18),
                  backgroundColor: DesignTokens.lavenderBg,
                  borderColor: DesignTokens.lavenderBorder,
                  onTap: onNavigateToChat,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: DesignTokens.maroon900.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: DesignTokens.lavenderText,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.assistantTitle,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: DesignTokens.lavenderText,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.assistantSubtitle,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: DesignTokens.slate600,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: DesignTokens.lavenderText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Top Opportunities Headline & View All
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.topOpportunitiesTitle,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onNavigateToOpportunities,
                      style: TextButton.styleFrom(
                        foregroundColor: DesignTokens.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.viewAll,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Top Matched Cards List (Stacked Content List Cards)
                if (opps.isLoading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 36),
                      child: CircularProgressIndicator(color: DesignTokens.primary),
                    ),
                  ),
                ] else if (opps.topMatchedOpportunities.isEmpty) ...[
                  RoundedCard(
                    padding: const EdgeInsets.all(28),
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 42,
                            color: DesignTokens.textMuted,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.noOpportunitiesFound,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ...opps.topMatchedOpportunities.map((opp) {
                    return _buildOpportunityCard(context, opp, langCode);
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(BuildContext context, Opportunity opp, String langCode) {
    final l10n = AppLocalizations.of(context)!;
    final elig = opp.eligibilityResult;
    final localizedTitle = opp.getLocalizedTitle(langCode);
    final localizedBenefit = opp.getLocalizedHighlightBenefit(l10n, langCode) ?? opp.highlightBenefit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RoundedCard(
        onTap: () => OpportunityDetailSheet.show(context, opp),
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category Pill (Top-left, blush/cream tint)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DesignTokens.blushBg,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                    border: Border.all(
                      color: DesignTokens.blushBorder,
                      width: 1.0,
                    ),
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
                // Status Pill (Top-right: sage green for eligible, warm yellow for attention)
                if (elig != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: elig.isEligible ? DesignTokens.sageBg : DesignTokens.mustardBg,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(
                        color: elig.isEligible ? DesignTokens.sageBorder : DesignTokens.mustardBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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

            // Bold Title (1–2 lines)
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
            const SizedBox(height: 8),

            // Benefit / Highlight
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
              const SizedBox(height: 10),
            ],

            // Forward arrow chevron footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  opp.location?.displayName ?? opp.getLocalizedTypeLabel(l10n),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: DesignTokens.slate600,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: DesignTokens.cream50,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
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
}
