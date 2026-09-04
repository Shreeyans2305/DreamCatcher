import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/opportunity.dart';
import '../../l10n/app_localizations.dart';

class OpportunityDetailSheet extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailSheet({super.key, required this.opportunity});

  static void show(BuildContext context, Opportunity opportunity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OpportunityDetailSheet(opportunity: opportunity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final elig = opportunity.eligibilityResult;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: DesignTokens.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: DesignTokens.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 12),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Tag & Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: DesignTokens.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                        ),
                        child: Text(
                          opportunity.typeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: DesignTokens.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (elig != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: elig.isEligible ? DesignTokens.mintBg : DesignTokens.mustardBg,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                            border: Border.all(
                              color: elig.isEligible ? DesignTokens.mintBorder : DesignTokens.mustardBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                elig.isEligible ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                size: 16,
                                color: elig.isEligible ? DesignTokens.mintText : DesignTokens.mustardText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                elig.isEligible ? l10n.eligibleBadge : l10n.notEligibleBadge,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: elig.isEligible ? DesignTokens.mintText : DesignTokens.mustardText,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Opportunity Title
                  Text(
                    opportunity.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Benefit Stat Block
                  if (opportunity.highlightBenefit != null) ...[
                    StatBlock(
                      stat: opportunity.highlightBenefit!,
                        label: opportunity.type == 'scholarship'
                          ? l10n.dashboardMatchedOpps
                          : l10n.topOpportunitiesTitle,
                      variant: StatBlockVariant.mint,
                      icon: Icons.monetization_on_outlined,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  if (opportunity.description != null && opportunity.description!.isNotEmpty) ...[
                    Text(
                      l10n.topOpportunitiesTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RoundedCard(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        opportunity.description!,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.5,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Plain-Language Eligibility Reasoning Breakdown
                  Text(
                    l10n.eligibilityReasoningTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (elig != null && elig.ruleEvaluations.isNotEmpty) ...[
                    RoundedCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.rulesPassed(elig.passedRulesCount, elig.totalRulesCount),
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: elig.isEligible ? DesignTokens.mintText : DesignTokens.textPrimary,
                                ),
                              ),
                              ProgressRing(
                                progress: elig.totalRulesCount > 0
                                    ? elig.passedRulesCount / elig.totalRulesCount
                                    : 1.0,
                                size: 36,
                                strokeWidth: 4,
                                showPercentage: false,
                                progressColor: elig.isEligible ? DesignTokens.mintText : DesignTokens.primary,
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          ...elig.ruleEvaluations.map((rule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: rule.passed
                                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                          : const Color(0xFFEF4444).withValues(alpha: 0.15),
                                    ),
                                    child: Icon(
                                      rule.passed ? Icons.check_rounded : Icons.close_rounded,
                                      size: 18,
                                      color: rule.passed ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rule.plainLanguageDescription,
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: DesignTokens.textPrimary,
                                          ),
                                        ),
                                        if (rule.studentValue != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Your profile: ${rule.studentValue}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: DesignTokens.textMuted,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ] else ...[
                    RoundedCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_outlined, color: DesignTokens.mintText, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Open to all students meeting standard general qualification.',
                              style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8))),
            ),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(l10n.applyNow),
              onPressed: () {
                final url = opportunity.applicationUrl ?? opportunity.officialUrl ?? 'https://scholarships.gov.in';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening official portal: $url'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
