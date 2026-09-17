import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/localization/opportunity_translator.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/api_client.dart';
import '../../data/india_locations.dart';
import '../../data/models/reference.dart';
import '../../data/models/student.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunities_provider.dart';
import '../onboarding/onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SkillItem> _catalogueSkills = [];
  List<InterestItem> _catalogueInterests = [];
  bool _isLoadingCatalogues = false;
  bool _isCompletedItemsExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadCatalogues();
  }

  Future<void> _loadCatalogues() async {
    setState(() => _isLoadingCatalogues = true);
    final client = context.read<DreamCatcherApiClient>();
    try {
      final results = await Future.wait([
        client.fetchSkills(pageSize: 50).catchError((_) => <SkillItem>[]),
        client.fetchInterests(pageSize: 50).catchError((_) => <InterestItem>[]),
      ]);
      _catalogueSkills = results[0] as List<SkillItem>;
      _catalogueInterests = results[1] as List<InterestItem>;
    } catch (e) {
      debugPrint('Error loading catalogues in profile: $e');
    } finally {
      if (mounted) setState(() => _isLoadingCatalogues = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final student = auth.currentStudent;
    final l10n = AppLocalizations.of(context)!;

    if (student == null) {
      return Scaffold(
        backgroundColor: DesignTokens.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.noOpportunitiesFound,
                style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
                child: Text(l10n.btnFinish),
              ),
            ],
          ),
        ),
      );
    }

    final education = student.educationRecords.isNotEmpty ? student.educationRecords.first : null;
    final aspiration = student.aspirations.isNotEmpty ? student.aspirations.first : null;
    final langCode = Localizations.localeOf(context).languageCode;
    final sanitizedEducationDesc = education?.description != null
        ? OpportunityTranslator.sanitizeEducationDescription(education!.description!, langCode)
        : '';

    final incomeDisplay = auth.familyIncome == 0
        ? l10n.nilIncome
        : auth.familyIncome <= 25000
            ? l10n.underIncome(auth.familyIncome.toStringAsFixed(0))
            : l10n.perYearIncome(auth.familyIncome.toStringAsFixed(0));

    final educationLevelDisplay = OpportunityTranslator.getEducationLevelName(
      education?.educationLevel ?? 'secondary',
      l10n,
    ).toUpperCase();

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(
          l10n.navProfile,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          if (_isLoadingCatalogues)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: DesignTokens.primary),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: DesignTokens.slate600),
            tooltip: l10n.navProfile,
            onPressed: () async {
              await auth.refreshProfile();
              if (context.mounted) {
                context.read<OpportunitiesProvider>().evaluateStudentEligibility();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Profile Summary Card with Avatar & Progress
            RoundedCard(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StudentAvatar(
                        avatarUrl: auth.avatarUrl,
                        name: student.name,
                        size: 66,
                        showEditBadge: true,
                        onTap: () {
                          showAvatarPickerBottomSheet(
                            context: context,
                            hasExistingAvatar: auth.avatarUrl != null && auth.avatarUrl!.isNotEmpty,
                            onAvatarSelected: (newAvatar) async {
                              await auth.updateAvatar(newAvatar);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      newAvatar != null ? 'Profile picture updated!' : 'Profile picture removed',
                                      style: GoogleFonts.inter(color: Colors.white),
                                    ),
                                    backgroundColor: DesignTokens.maroon900,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: DesignTokens.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (student.phone != null)
                              Text(
                                student.phone!,
                                style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
                              ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () => _showEditLocationDialog(context, auth),
                              borderRadius: BorderRadius.circular(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: DesignTokens.slate600),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      student.location?.displayName ?? l10n.locationNotSet,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: DesignTokens.textPrimary,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationStyle: TextDecorationStyle.dotted,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.edit_outlined, size: 12, color: DesignTokens.slate600),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: DesignTokens.cream50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: DesignTokens.border),
                    ),
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: student.effectiveCompleteness,
                          size: 38,
                          strokeWidth: 4,
                          showPercentage: false,
                          progressColor: DesignTokens.maroon900,
                          backgroundColor: DesignTokens.blush200,
                          centerWidget: Text(
                            '${student.completenessPercentage}%',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: DesignTokens.maroon900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${student.completenessPercentage}% Profile Completed',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: DesignTokens.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                student.completenessPercentage >= 90
                                    ? 'Your profile is fully verified for all schemes!'
                                    : 'Complete education, skills & photo to boost scheme match',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: DesignTokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Completeness Checklist & Missing Steps
            _buildCompletenessChecklistCard(context, auth, student, l10n),
            const SizedBox(height: 16),

            // Preferred Language Row (Slim White Card)
            _buildLanguageSelector(context, auth),
            const SizedBox(height: 22),

            // Demographics & Quotas Section
            _buildSectionHeader(
              title: l10n.demographicsTitle,
              onAddOrEdit: () => _showEditDemographicsDialog(context, auth),
              editLabel: l10n.btnUpdate,
            ),
            const SizedBox(height: 10),
            RoundedCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  _buildDemographicRow(
                    icon: Icons.map_outlined,
                    label: '${l10n.stateLabel} & ${l10n.districtLabel}',
                    value: student.location?.displayName ?? l10n.locationNotSet,
                  ),
                  const Divider(height: 20, color: DesignTokens.border),
                  _buildDemographicRow(
                    icon: Icons.badge_outlined,
                    label: l10n.socialCategoryLabel,
                    value: OpportunityTranslator.getSocialCategoryName(auth.socialCategory, l10n),
                  ),
                  const Divider(height: 20, color: DesignTokens.border),
                  _buildDemographicRow(
                    icon: Icons.diversity_3_outlined,
                    label: l10n.tribeLabel,
                    value: auth.tribe.isNotEmpty ? auth.tribe : l10n.noneSpecified,
                    isTribe: auth.tribe.isNotEmpty,
                  ),
                  const Divider(height: 20, color: DesignTokens.border),
                  _buildDemographicRow(
                    icon: Icons.currency_rupee_rounded,
                    label: l10n.annualIncomeLabel,
                    value: incomeDisplay,
                    isZeroAid: auth.familyIncome <= 25000,
                  ),
                  const Divider(height: 20, color: DesignTokens.border),
                  _buildDemographicRow(
                    icon: Icons.holiday_village_outlined,
                    label: l10n.areaClassificationLabel,
                    value: OpportunityTranslator.getAreaClassificationName(auth.ruralUrban, l10n).toUpperCase(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Education Section
            _buildSectionHeader(
              title: l10n.educationSectionTitle,
              onAddOrEdit: () => _showEditEducationDialog(context, auth),
              editLabel: l10n.btnUpdate,
            ),
            const SizedBox(height: 10),
            RoundedCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, color: DesignTokens.slate600, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          educationLevelDisplay,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sanitizedEducationDesc.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      sanitizedEducationDesc,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: DesignTokens.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.noEducationDescription,
                      style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Skills Section
            _buildSectionHeader(
              title: l10n.skillsSectionTitle(student.skills.length),
              onAddOrEdit: () => _showAddSkillDialog(context, auth),
              editLabel: l10n.btnAddSkill,
            ),
            const SizedBox(height: 10),
            RoundedCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              child: student.skills.isEmpty
                  ? Text(
                      l10n.noSkillsAdded,
                      style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: student.skills.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: DesignTokens.blushBg,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                            border: Border.all(color: DesignTokens.blushBorder),
                          ),
                          child: Text(
                            s.skill?.canonicalName ?? l10n.addSkill,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DesignTokens.maroon900,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // Interests Section
            _buildSectionHeader(
              title: l10n.interestsSectionTitle(student.interests.length),
              onAddOrEdit: () => _showAddInterestDialog(context, auth),
              editLabel: l10n.btnAddInterest,
            ),
            const SizedBox(height: 10),
            RoundedCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              child: student.interests.isEmpty
                  ? Text(
                      l10n.noInterestsAdded,
                      style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: student.interests.map((i) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: DesignTokens.lavenderBg,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                            border: Border.all(color: DesignTokens.lavenderBorder),
                          ),
                          child: Text(
                            i.interest?.name ?? l10n.addInterest,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DesignTokens.lavenderText,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // Aspirations Section
            _buildSectionHeader(
              title: l10n.careerAspirationTitle,
              onAddOrEdit: () => _showEditAspirationDialog(context, auth),
              editLabel: l10n.btnUpdate,
            ),
            const SizedBox(height: 10),
            RoundedCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFD4A31C), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      aspiration?.aspirationText ?? l10n.noAspirationAdded,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: DesignTokens.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reset / Switch Profile Button
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.logout_rounded, color: DesignTokens.slate600, size: 18),
                label: Text(
                  l10n.btnSwitchProfile,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.slate600,
                  ),
                ),
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AuthProvider auth) {
    final l10n = AppLocalizations.of(context)!;
    final languages = Language.defaultLanguages
        .where((language) => AppLocalizations.supportedLocales.any(
              (locale) => locale.languageCode == language.code,
            ))
        .toList();

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      backgroundColor: Colors.white,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: languages.any((language) => language.code == auth.preferredLanguage)
              ? auth.preferredLanguage
              : languages.first.code,
          icon: const Icon(Icons.translate_rounded, color: DesignTokens.slate600, size: 20),
          items: languages.map((language) {
            return DropdownMenuItem<String>(
              value: language.code,
              child: Text(
                '${l10n.preferredLanguageLabel}: ${language.name} (${language.nativeName})',
                style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textPrimary),
              ),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null && value != auth.preferredLanguage) {
              await auth.updatePreferredLanguage(value);
              if (context.mounted) {
                context.read<OpportunitiesProvider>().evaluateStudentEligibility();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onAddOrEdit,
    required String editLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DesignTokens.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onAddOrEdit,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            editLabel,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: DesignTokens.slate600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemographicRow({
    required IconData icon,
    required String label,
    required String value,
    bool isTribe = false,
    bool isZeroAid = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 19, color: DesignTokens.slate600),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isZeroAid
                  ? DesignTokens.sageBg
                  : (isTribe ? DesignTokens.blushBg : DesignTokens.cream50),
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: isZeroAid
                    ? DesignTokens.sageBorder
                    : (isTribe ? DesignTokens.blushBorder : DesignTokens.border),
                width: 1.0,
              ),
            ),
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isZeroAid
                    ? DesignTokens.sageText
                    : (isTribe ? DesignTokens.maroon900 : DesignTokens.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSkillDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    final l10n = AppLocalizations.of(context)!;
    if (student == null) return;

    final existingSkillIds = student.skills.map((s) => s.skillId).toSet();
    final availableSkills = _catalogueSkills.where((s) => !existingSkillIds.contains(s.id)).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.dialogAddSkillTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: availableSkills.isEmpty
              ? Text(l10n.dialogAllSkillsAdded)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableSkills.length,
                  itemBuilder: (c, idx) {
                    final skill = availableSkills[idx];
                    return ListTile(
                      title: Text(skill.canonicalName, style: const TextStyle(fontSize: 15)),
                      subtitle: Text(skill.category, style: const TextStyle(fontSize: 13)),
                      trailing: const Icon(Icons.add_circle_outline_rounded, color: DesignTokens.primary),
                      onTap: () async {
                        Navigator.pop(ctx);
                        try {
                          await client.addStudentSkill(student.id, skillId: skill.id);
                          await auth.refreshProfile();
                          if (context.mounted) {
                            context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.snackbarSkillAdded(skill.canonicalName))),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.snackbarError(e.toString()))),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.btnCancel),
          ),
        ],
      ),
    );
  }

  void _showAddInterestDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    final l10n = AppLocalizations.of(context)!;
    if (student == null) return;

    final existingIds = student.interests.map((i) => i.interestId).toSet();
    final available = _catalogueInterests.where((i) => !existingIds.contains(i.id)).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.dialogAddInterestTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: available.isEmpty
              ? Text(l10n.dialogAllInterestsAdded)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: available.length,
                  itemBuilder: (c, idx) {
                    final item = available[idx];
                    return ListTile(
                      title: Text(item.name, style: const TextStyle(fontSize: 15)),
                      subtitle: Text(item.category, style: const TextStyle(fontSize: 13)),
                      trailing: const Icon(Icons.add_circle_outline_rounded, color: DesignTokens.primary),
                      onTap: () async {
                        Navigator.pop(ctx);
                        try {
                          await client.addStudentInterest(student.id, interestId: item.id);
                          await auth.refreshProfile();
                          if (context.mounted) {
                            context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.snackbarInterestAdded(item.name))),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.snackbarError(e.toString()))),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.btnCancel),
          ),
        ],
      ),
    );
  }

  void _showEditEducationDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    final l10n = AppLocalizations.of(context)!;
    if (student == null) return;

    final existingEdu = student.educationRecords.isNotEmpty ? student.educationRecords.first : null;
    final textController = TextEditingController(text: existingEdu?.description ?? '');
    String selectedLevel = existingEdu?.educationLevel ?? 'secondary';

    final educationOptions = [
      'primary',
      'upper_primary',
      'secondary',
      'senior_secondary',
      'diploma',
      'vocational',
      'bachelor',
      'master',
      'informal',
      'self_learning',
      'other',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            l10n.dialogUpdateEducationTitle,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dialogEduLevelLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                DropdownButton<String>(
                  isExpanded: true,
                  value: educationOptions.contains(selectedLevel)
                      ? selectedLevel
                      : 'secondary',
                  items: educationOptions.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(OpportunityTranslator.getEducationLevelName(level, l10n)),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedLevel = v);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.dialogEduDescLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.dialogEduDescHint,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await client.addStudentEducation(
                    student.id,
                    educationLevel: selectedLevel,
                    description: textController.text.trim(),
                  );
                  await auth.refreshProfile();
                  if (context.mounted) {
                    context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.snackbarEducationUpdated)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.snackbarError(e.toString()))),
                    );
                  }
                }
              },
              child: Text(l10n.btnSave),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAspirationDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    final l10n = AppLocalizations.of(context)!;
    if (student == null) return;

    final existingAsp = student.aspirations.isNotEmpty ? student.aspirations.first.aspirationText : '';
    final textController = TextEditingController(text: existingAsp);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.dialogAspirationTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: TextField(
          controller: textController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: l10n.dialogAspirationHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.btnCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = textController.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await client.addStudentAspiration(student.id, aspirationText: text);
                await auth.refreshProfile();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.snackbarAspirationUpdated)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.snackbarError(e.toString()))),
                  );
                }
              }
            },
            child: Text(l10n.btnSave),
          ),
        ],
      ),
    );
  }

  void _showEditDemographicsDialog(BuildContext context, AuthProvider auth) {
    final l10n = AppLocalizations.of(context)!;
    String selectedCategory = auth.socialCategory;
    String selectedTribe = auth.tribe;
    double selectedIncome = auth.familyIncome;
    final tribeController = TextEditingController(text: selectedTribe);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            l10n.dialogDemographicsTitle,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dialogCasteQuotaLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ['General', 'OBC', 'SC', 'ST', 'EWS'].map((cat) {
                    final isSel = selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(OpportunityTranslator.getSocialCategoryName(cat, l10n)),
                      selected: isSel,
                      selectedColor: DesignTokens.maroon900,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : DesignTokens.textPrimary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(color: isSel ? DesignTokens.maroon900 : DesignTokens.border),
                      onSelected: (sel) {
                        if (sel) setDialogState(() => selectedCategory = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(l10n.dialogTribeLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  l10n.dialogTribeSubtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: DesignTokens.slate600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ['Bhil', 'Gond', 'Santhal', 'Munda', 'Oraon', 'Bodo', 'Warli', 'Khasi', 'Garo', 'PVTG'].map((t) {
                    final isSel = selectedTribe.toLowerCase() == t.toLowerCase();
                    return ChoiceChip(
                      label: Text(t),
                      selected: isSel,
                      selectedColor: DesignTokens.maroon900,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSel ? Colors.white : DesignTokens.textPrimary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(color: isSel ? DesignTokens.maroon900 : DesignTokens.border),
                      onSelected: (sel) {
                        setDialogState(() {
                          selectedTribe = sel ? t : '';
                          tribeController.text = selectedTribe;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tribeController,
                  decoration: InputDecoration(
                    hintText: l10n.dialogTribeCustomHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (val) => selectedTribe = val,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.dialogIncomeLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                      selectedIncome == 0
                          ? l10n.nilIncome
                          : selectedIncome <= 25000
                              ? l10n.underIncome(selectedIncome.toStringAsFixed(0))
                              : l10n.perYearIncome('${(selectedIncome / 1000).toStringAsFixed(0)}k'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIncome <= 25000 ? DesignTokens.sageText : DesignTokens.maroon900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDialogIncomePill('₹0', 0, selectedIncome, (v) => setDialogState(() => selectedIncome = v)),
                      const SizedBox(width: 6),
                      _buildDialogIncomePill('< ₹25k', 25000, selectedIncome, (v) => setDialogState(() => selectedIncome = v)),
                      const SizedBox(width: 6),
                      _buildDialogIncomePill('₹1L', 100000, selectedIncome, (v) => setDialogState(() => selectedIncome = v)),
                      const SizedBox(width: 6),
                      _buildDialogIncomePill('₹2.5L', 250000, selectedIncome, (v) => setDialogState(() => selectedIncome = v)),
                      const SizedBox(width: 6),
                      _buildDialogIncomePill('₹5L+', 500000, selectedIncome, (v) => setDialogState(() => selectedIncome = v)),
                    ],
                  ),
                ),
                Slider(
                  value: selectedIncome,
                  min: 0,
                  max: 800000,
                  divisions: 32,
                  activeColor: DesignTokens.maroon900,
                  inactiveColor: DesignTokens.blush200,
                  onChanged: (v) => setDialogState(() => selectedIncome = v),
                ),
                if (selectedIncome <= 25000)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DesignTokens.sageBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: DesignTokens.sageBorder),
                    ),
                    child: Text(
                      l10n.qualifiesFullWaiver,
                      style: const TextStyle(fontSize: 12, color: DesignTokens.sageText, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final finalTribe = tribeController.text.trim();
                await auth.updateDemographics(
                  socialCategory: selectedCategory,
                  tribe: finalTribe,
                  familyIncome: selectedIncome,
                );
                if (context.mounted) {
                  context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.snackbarDemographicsUpdated)),
                  );
                }
              },
              child: Text(l10n.btnSave),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogIncomePill(String label, double val, double currentVal, ValueChanged<double> onSelect) {
    final isSel = (currentVal == val);
    return InkWell(
      onTap: () => onSelect(val),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSel ? DesignTokens.maroon900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSel ? DesignTokens.maroon900 : DesignTokens.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSel ? Colors.white : DesignTokens.textPrimary,
            fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showEditLocationDialog(BuildContext context, AuthProvider auth) {
    final l10n = AppLocalizations.of(context)!;
    final student = auth.currentStudent;
    String selectedState = (student?.location?.state != null && student!.location!.state!.isNotEmpty)
        ? student.location!.state!
        : IndiaLocations.defaultState;
    String selectedDistrict = (student?.location?.district != null && student!.location!.district!.isNotEmpty)
        ? student.location!.district!
        : IndiaLocations.defaultDistrict(selectedState);
    String selectedRuralUrban = auth.ruralUrban;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            '${l10n.stateLabel} & ${l10n.districtLabel}',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // State Field
                LocationSelectorField(
                  label: l10n.stateLabel,
                  value: selectedState,
                  hintText: 'Select State or UT',
                  icon: Icons.map_outlined,
                  isRequired: true,
                  onTap: () async {
                    final chosen = await showSearchableLocationPicker(
                      dialogCtx,
                      title: '${l10n.stateLabel} (India)',
                      searchHint: 'Search state or UT...',
                      items: IndiaLocations.states,
                      selectedItem: selectedState,
                    );
                    if (chosen != null) {
                      setDialogState(() {
                        selectedState = chosen;
                        final dists = IndiaLocations.getDistricts(chosen);
                        if (!dists.contains(selectedDistrict)) {
                          selectedDistrict = dists.isNotEmpty ? dists.first : '';
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),

                // District Field
                LocationSelectorField(
                  label: l10n.districtLabel,
                  value: selectedDistrict,
                  hintText: 'Select District',
                  icon: Icons.location_city_rounded,
                  isRequired: true,
                  onTap: () async {
                    final dists = IndiaLocations.getDistricts(selectedState);
                    final chosen = await showSearchableLocationPicker(
                      dialogCtx,
                      title: '${l10n.districtLabel} ($selectedState)',
                      searchHint: 'Search district in $selectedState...',
                      items: dists,
                      selectedItem: selectedDistrict,
                    );
                    if (chosen != null) {
                      setDialogState(() => selectedDistrict = chosen);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Area Classification
                Text(
                  l10n.areaClassificationLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Center(child: Text(l10n.rural)),
                        selected: selectedRuralUrban == 'rural',
                        selectedColor: DesignTokens.maroon900,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedRuralUrban == 'rural' ? Colors.white : DesignTokens.textPrimary,
                          fontWeight: selectedRuralUrban == 'rural' ? FontWeight.w600 : FontWeight.normal,
                        ),
                        onSelected: (sel) {
                          if (sel) setDialogState(() => selectedRuralUrban = 'rural');
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(child: Text(l10n.semiUrban)),
                        selected: selectedRuralUrban == 'semi_urban',
                        selectedColor: DesignTokens.maroon900,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedRuralUrban == 'semi_urban' ? Colors.white : DesignTokens.textPrimary,
                          fontWeight: selectedRuralUrban == 'semi_urban' ? FontWeight.w600 : FontWeight.normal,
                        ),
                        onSelected: (sel) {
                          if (sel) setDialogState(() => selectedRuralUrban = 'semi_urban');
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(child: Text(l10n.urban)),
                        selected: selectedRuralUrban == 'urban',
                        selectedColor: DesignTokens.maroon900,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedRuralUrban == 'urban' ? Colors.white : DesignTokens.textPrimary,
                          fontWeight: selectedRuralUrban == 'urban' ? FontWeight.w600 : FontWeight.normal,
                        ),
                        onSelected: (sel) {
                          if (sel) setDialogState(() => selectedRuralUrban = 'urban');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await auth.updateLocation(
                  state: selectedState,
                  district: selectedDistrict,
                  ruralUrban: selectedRuralUrban,
                );
                if (context.mounted) {
                  context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location updated successfully!')),
                  );
                }
              },
              child: Text(l10n.btnSave),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletenessChecklistCard(
    BuildContext context,
    AuthProvider auth,
    StudentProfile student,
    AppLocalizations l10n,
  ) {
    if (student.missingSteps.isEmpty) {
      return RoundedCard(
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.white,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DesignTokens.sageBg,
                border: Border.all(color: DesignTokens.sageBorder),
              ),
              child: const Icon(Icons.verified_rounded, color: DesignTokens.sageText, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '100% Profile Complete! 🎉',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'All scheme criteria & quotas are fully unlocked for you.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final totalRemainingPoints = student.missingSteps.fold<int>(0, (sum, s) => sum + s.points);

    return RoundedCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DesignTokens.blush200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.checklist_rtl_rounded,
                  color: DesignTokens.maroon900,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Missing Items for 100% Profile',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${student.missingSteps.length} items left • +$totalRemainingPoints% remaining',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: DesignTokens.border),
          const SizedBox(height: 10),
          // Missing Step Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: student.missingSteps.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (ctx, idx) {
              final step = student.missingSteps[idx];
              return InkWell(
                onTap: () => _onTapCompletenessStep(context, auth, step.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: DesignTokens.cream50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: DesignTokens.border),
                  ),
                  child: Row(
                    children: [
                      Icon(_getStepIcon(step.id), size: 18, color: DesignTokens.maroon900),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                            Text(
                              step.description,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: DesignTokens.slate600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: DesignTokens.blush200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${step.points}%',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.maroon900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: DesignTokens.slate600),
                    ],
                  ),
                ),
              );
            },
          ),
          if (student.completedSteps.isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => setState(() => _isCompletedItemsExpanded = !_isCompletedItemsExpanded),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _isCompletedItemsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: DesignTokens.slate600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_isCompletedItemsExpanded ? 'Hide' : 'Show'} completed items (${student.completedSteps.length})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.slate600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isCompletedItemsExpanded) ...[
              const SizedBox(height: 8),
              for (final step in student.completedSteps)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: DesignTokens.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step.title,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: DesignTokens.slate600,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      Text(
                        '${step.points}%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: DesignTokens.slate600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  IconData _getStepIcon(CompletenessStepId id) {
    switch (id) {
      case CompletenessStepId.education:
        return Icons.school_outlined;
      case CompletenessStepId.skills:
        return Icons.psychology_outlined;
      case CompletenessStepId.location:
        return Icons.location_on_outlined;
      case CompletenessStepId.interests:
        return Icons.favorite_outline_rounded;
      case CompletenessStepId.phone:
        return Icons.phone_outlined;
      case CompletenessStepId.demographics:
        return Icons.badge_outlined;
      case CompletenessStepId.avatar:
        return Icons.camera_alt_outlined;
      case CompletenessStepId.aspirations:
        return Icons.flag_outlined;
    }
  }

  void _onTapCompletenessStep(BuildContext context, AuthProvider auth, CompletenessStepId stepId) {
    switch (stepId) {
      case CompletenessStepId.avatar:
        showAvatarPickerBottomSheet(
          context: context,
          hasExistingAvatar: auth.avatarUrl != null && auth.avatarUrl!.isNotEmpty,
          onAvatarSelected: (newAvatar) async {
            await auth.updateAvatar(newAvatar);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    newAvatar != null ? 'Profile picture updated!' : 'Profile picture removed',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                  backgroundColor: DesignTokens.maroon900,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
        break;
      case CompletenessStepId.education:
        _showEditEducationDialog(context, auth);
        break;
      case CompletenessStepId.skills:
        _showAddSkillDialog(context, auth);
        break;
      case CompletenessStepId.interests:
        _showAddInterestDialog(context, auth);
        break;
      case CompletenessStepId.aspirations:
        _showEditAspirationDialog(context, auth);
        break;
      case CompletenessStepId.location:
        _showEditLocationDialog(context, auth);
        break;
      case CompletenessStepId.demographics:
      case CompletenessStepId.phone:
        _showEditBasicInfoDialog(context, auth);
        break;
    }
  }

  void _showEditBasicInfoDialog(BuildContext context, AuthProvider auth) {
    final student = auth.currentStudent;
    if (student == null) return;
    final phoneController = TextEditingController(text: student.phone ?? '');
    final emailController = TextEditingController(text: student.email ?? '');
    final dobController = TextEditingController(text: student.dateOfBirth ?? '');
    String selectedGender = student.gender ?? 'male';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit Basic Information',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 9876543210',
                    prefixIcon: Icon(Icons.phone_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Date of Birth (YYYY-MM-DD)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: dobController,
                  decoration: InputDecoration(
                    hintText: 'e.g. 2005-04-12',
                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: dialogCtx,
                          initialDate: DateTime.tryParse(dobController.text) ?? DateTime(2005, 1, 1),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            dobController.text =
                                "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final g in ['male', 'female', 'other', 'prefer_not_to_say'])
                      ChoiceChip(
                        label: Text(
                          g == 'prefer_not_to_say'
                              ? 'Prefer not to say'
                              : g[0].toUpperCase() + g.substring(1),
                        ),
                        selected: selectedGender.toLowerCase() == g.toLowerCase(),
                        selectedColor: DesignTokens.maroon900,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedGender.toLowerCase() == g.toLowerCase()
                              ? Colors.white
                              : DesignTokens.textPrimary,
                          fontWeight: selectedGender.toLowerCase() == g.toLowerCase()
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        onSelected: (sel) {
                          if (sel) setDialogState(() => selectedGender = g);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Email (Optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'e.g. student@example.com',
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final client = context.read<DreamCatcherApiClient>();
                await client.updateStudent(
                  student.id,
                  {
                    if (phoneController.text.trim().isNotEmpty) 'phone': phoneController.text.trim(),
                    if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
                    if (dobController.text.trim().isNotEmpty) 'date_of_birth': dobController.text.trim(),
                    'gender': selectedGender,
                  },
                );
                await auth.refreshProfile();
                if (context.mounted) {
                  context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile information updated')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
