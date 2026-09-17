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
    final langCode = Localizations.localeOf(context).languageCode;
    final elig = opportunity.eligibilityResult;
    final localizedTitle = opportunity.getLocalizedTitle(langCode);
    final localizedDesc = opportunity.getLocalizedDescription(langCode);
    final localizedBenefit = opportunity.getLocalizedHighlightBenefit(l10n, langCode) ?? opportunity.highlightBenefit;

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
              color: DesignTokens.slate600.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 14),

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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: DesignTokens.blushBg,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                          border: Border.all(color: DesignTokens.blushBorder),
                        ),
                        child: Text(
                          opportunity.getLocalizedTypeLabel(l10n),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: DesignTokens.maroon900,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (elig != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: elig.isEligible ? DesignTokens.sageBg : DesignTokens.mustardBg,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                            border: Border.all(
                              color: elig.isEligible ? DesignTokens.sageBorder : DesignTokens.mustardBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                elig.isEligible ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                size: 14,
                                color: elig.isEligible ? DesignTokens.sageText : DesignTokens.mustardText,
                              ),
                              const SizedBox(width: 5),
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
                  const SizedBox(height: 14),

                  // Opportunity Title
                  Text(
                    localizedTitle,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textPrimary,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Benefit Stat Block
                  if (localizedBenefit != null && localizedBenefit.isNotEmpty) ...[
                    StatBlock(
                      stat: localizedBenefit,
                      label: opportunity.type == 'scholarship'
                          ? l10n.statFinancialBenefit
                          : l10n.statKeyDetails,
                      variant: StatBlockVariant.mint,
                      icon: Icons.monetization_on_outlined,
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Description
                  if (localizedDesc != null && localizedDesc.isNotEmpty) ...[
                    Text(
                      l10n.opportunityAbout,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RoundedCard(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.white,
                      child: Text(
                        localizedDesc,
                        style: GoogleFonts.inter(
                          fontSize: 15,
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
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (elig != null && elig.ruleEvaluations.isNotEmpty) ...[
                    RoundedCard(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.white,
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
                                  fontWeight: FontWeight.w700,
                                  color: elig.isEligible ? DesignTokens.sageText : DesignTokens.textPrimary,
                                ),
                              ),
                              ProgressRing(
                                progress: elig.totalRulesCount > 0
                                    ? elig.passedRulesCount / elig.totalRulesCount
                                    : 1.0,
                                size: 38,
                                strokeWidth: 4,
                                showPercentage: false,
                                progressColor: elig.isEligible ? DesignTokens.sageText : DesignTokens.maroon900,
                                backgroundColor: DesignTokens.blush200,
                              ),
                            ],
                          ),
                          const Divider(height: 24, color: DesignTokens.border),
                          ...elig.ruleEvaluations.map((rule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: rule.passed
                                          ? DesignTokens.sageBg
                                          : DesignTokens.mustardBg,
                                      border: Border.all(
                                        color: rule.passed
                                            ? DesignTokens.sageBorder
                                            : DesignTokens.mustardBorder,
                                      ),
                                    ),
                                    child: Icon(
                                      rule.passed ? Icons.check_rounded : Icons.close_rounded,
                                      size: 16,
                                      color: rule.passed ? DesignTokens.sageText : DesignTokens.mustardText,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rule.getLocalizedDescription(langCode),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: DesignTokens.textPrimary,
                                          ),
                                        ),
                                        if (rule.studentValue != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            l10n.yourProfileValue(_formatStudentValue(rule, l10n)),
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: DesignTokens.slate600,
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
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.white,
                      child: Row(
                        children: [
                          const Icon(Icons.verified_outlined, color: DesignTokens.sageText, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.openToAllGeneral,
                              style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8))),
              boxShadow: [
                BoxShadow(
                  color: DesignTokens.maroon900.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(l10n.applyNow),
                onPressed: () {
                  final url = opportunity.applicationUrl ?? opportunity.officialUrl ?? 'https://scholarships.gov.in';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.officialPortalOpening(url)),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatStudentValue(dynamic ruleItem, AppLocalizations l10n) {
    final val = ruleItem.studentValue;
    if (val == null || val == 'null' || val.toString().trim().isEmpty) {
      return l10n.noneSpecified;
    }
    final rt = ruleItem.ruleType.toString().toLowerCase();
    if (rt.contains('income')) {
      final numVal = double.tryParse(val.toString());
      if (numVal != null) {
        return '₹${numVal.toInt()}';
      }
    }
    return val.toString();
  }
}
