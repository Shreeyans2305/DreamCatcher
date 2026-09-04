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

    final name = student?.name.split(' ').first ?? 'Friend';
    final completenessPercent = (student?.profileCompleteness != null)
        ? (student!.profileCompleteness * 100).round()
        : 0;
    final matchedCount = opps.totalMatchedCount;
    final region = student?.location?.district ?? student?.location?.state ?? 'your area';

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: DesignTokens.primary,
          onRefresh: () async {
            await Future.wait([
              auth.refreshProfile(),
              opps.fetchOpportunities(),
            ]);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Greeting Headline
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.greeting(name),
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: DesignTokens.textPrimary,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.tagline,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onNavigateToProfile,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignTokens.primaryLight,
                          border: Border.all(color: DesignTokens.primary.withValues(alpha: 0.3)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'S',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // StatBlock Row (Profile Completeness & Matched Opportunities)
                Row(
                  children: [
                    Expanded(
                      child: StatBlock(
                        stat: '$completenessPercent%',
                        label: l10n.dashboardCompleteness,
                        variant: StatBlockVariant.mustard,
                        icon: Icons.pie_chart_outline_rounded,
                        onTap: onNavigateToProfile,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                const SizedBox(height: 20),

                // Social Proof with AvatarStack
                RoundedCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  backgroundColor: Colors.white,
                  child: AvatarStack(
                    label: matchedCount > 0
                      ? '${l10n.dashboardMatchedOpps}: $matchedCount ($region)'
                      : '${l10n.viewAll}: $region',
                    totalCount: matchedCount > 0 ? matchedCount : opps.allOpportunities.length,
                  ),
                ),
                const SizedBox(height: 24),

                // Assistant Callout Banner (Informational Lavender)
                RoundedCard(
                  padding: const EdgeInsets.all(18),
                  backgroundColor: DesignTokens.lavenderBg,
                  borderColor: DesignTokens.lavenderBorder,
                  onTap: onNavigateToChat,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: DesignTokens.lavenderText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.assistantTitle,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: DesignTokens.lavenderText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.assistantSubtitle,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: DesignTokens.lavenderText.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: DesignTokens.lavenderText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Top Opportunities Headline & View All
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.topOpportunitiesTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: onNavigateToOpportunities,
                      child: Text(
                        l10n.viewAll,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Top Matched Cards List
                if (opps.isLoading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(color: DesignTokens.primary),
                    ),
                  ),
                ] else if (opps.topMatchedOpportunities.isEmpty) ...[
                  RoundedCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, size: 40, color: DesignTokens.textMuted),
                          const SizedBox(height: 8),
                          Text(
                            l10n.noOpportunitiesFound,
                            style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ...opps.topMatchedOpportunities.map((opp) {
                    return _buildOpportunityCard(context, opp);
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(BuildContext context, Opportunity opp) {
    final l10n = AppLocalizations.of(context)!;
    final elig = opp.eligibilityResult;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RoundedCard(
        onTap: () => OpportunityDetailSheet.show(context, opp),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category Pill
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
                // Status Pill
                if (elig != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: elig.isEligible ? DesignTokens.mintBg : DesignTokens.mustardBg,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                    ),
                    child: Text(
                      elig.isEligible ? l10n.eligibleBadge : l10n.notEligibleBadge,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: elig.isEligible ? DesignTokens.mintText : DesignTokens.mustardText,
                      ),
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
            const SizedBox(height: 8),

            // Benefit / highlight
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

            // Footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap to see criteria & apply',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: DesignTokens.textMuted,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: DesignTokens.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
