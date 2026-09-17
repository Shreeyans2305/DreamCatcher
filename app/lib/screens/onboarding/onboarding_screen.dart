import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/india_locations.dart';
import '../../data/models/reference.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../main_shell.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingCatalogues) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: DesignTokens.primary),
                    SizedBox(height: 16),
                    Text(
                      'Connecting to DreamCatcher...',
                      style: TextStyle(fontSize: 15, color: DesignTokens.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Top Header with Progress Ring & Step Title
                _buildHeader(context, provider),

                // Form Page Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: _buildStepContent(context, provider),
                  ),
                ),

                // Bottom Sticky Action Button
                _buildBottomNav(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final stepTitles = [
      l10n.stepBasic,
      l10n.stepLocation,
      l10n.stepEducation,
      l10n.skillsTitle,
      l10n.stepAspirations,
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8)),
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.maroon900.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ProgressRing(
            progress: provider.stepProgress,
            size: 50,
            strokeWidth: 5,
            showPercentage: true,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${provider.currentStep + 1} / ${provider.totalSteps}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.slate600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stepTitles[provider.currentStep],
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          if (provider.currentStep > 0)
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DesignTokens.cream50,
                border: Border.all(color: DesignTokens.border),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: DesignTokens.maroon900),
                onPressed: provider.prevStep,
                tooltip: l10n.btnBack,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, OnboardingProvider provider) {
    switch (provider.currentStep) {
      case 0:
        return _buildStep0Basic(context, provider);
      case 1:
        return _buildStep1Location(context, provider);
      case 2:
        return _buildStep2Education(context, provider);
      case 3:
        return _buildStep3SkillsAndInterests(context, provider);
      case 4:
        return _buildStep4Aspirations(context, provider);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // Step 0: Basic Info & Language
  // ---------------------------------------------------------------------------
  Widget _buildStep0Basic(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Motivational Copy Block
        Text(
          "Let's build your future path",
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.onboardingSubtitle,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: DesignTokens.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        // Profile Photo Picker (Optional)
        Center(
          child: Column(
            children: [
              StudentAvatar(
                avatarUrl: provider.avatarUrl,
                name: provider.name.isNotEmpty ? provider.name : 'Student',
                size: 78,
                showEditBadge: true,
                onTap: () {
                  showAvatarPickerBottomSheet(
                    context: context,
                    hasExistingAvatar: provider.avatarUrl != null && provider.avatarUrl!.isNotEmpty,
                    onAvatarSelected: provider.setAvatarUrl,
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Add Profile Photo (Optional)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: DesignTokens.slate600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Full Name
        Text(
          '${l10n.fullNameLabel} *',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.name,
          onChanged: provider.setName,
          decoration: InputDecoration(
            hintText: l10n.fullNameHint,
            prefixIcon: const Icon(Icons.person_outline_rounded, color: DesignTokens.slate600, size: 20),
          ),
        ),
        const SizedBox(height: 20),

        // Phone Number
        Text(
          l10n.phoneLabel,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.phone,
          keyboardType: TextInputType.phone,
          onChanged: provider.setPhone,
          decoration: InputDecoration(
            hintText: l10n.phoneHint,
            prefixIcon: const Icon(Icons.phone_outlined, color: DesignTokens.slate600, size: 20),
          ),
        ),
        const SizedBox(height: 20),

        // Preferred Language
        Text(
          l10n.preferredLanguageLabel,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final uniqueLangs = <String, Language>{};
            for (final l in provider.languages) {
              uniqueLangs[l.code] = l;
            }
            final langList = uniqueLangs.values.toList();
            final currentLang = provider.preferredLanguage;
            final effectiveLang = uniqueLangs.containsKey(currentLang)
                ? currentLang
                : (langList.isNotEmpty ? langList.first.code : null);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                border: Border.all(color: DesignTokens.border),
                boxShadow: DesignTokens.softShadow,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: effectiveLang,
                  hint: Text(
                    l10n.selectLanguage,
                    style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textMuted),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: DesignTokens.slate600),
                  items: langList.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang.code,
                      child: Text(
                        '${lang.name} (${lang.nativeName})',
                        style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textPrimary),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) provider.setLanguage(val);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1: Location & Background Demographics
  // ---------------------------------------------------------------------------
  Widget _buildStep1Location(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.stateLabel} & ${l10n.districtLabel}',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Many government scholarships are reserved for specific states, districts, and rural regions.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: DesignTokens.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // Dynamic Indian State Selector
        LocationSelectorField(
          label: l10n.stateLabel,
          value: provider.selectedState,
          hintText: 'Select State or Union Territory',
          icon: Icons.map_outlined,
          isRequired: true,
          onTap: () async {
            final chosen = await showSearchableLocationPicker(
              context,
              title: '${l10n.stateLabel} (India)',
              searchHint: 'Search state or UT (e.g. Maharashtra, Bihar, Tamil Nadu)...',
              items: IndiaLocations.states,
              selectedItem: provider.selectedState,
            );
            if (chosen != null) {
              provider.setStateSelection(chosen);
            }
          },
        ),
        const SizedBox(height: 16),

        // Dynamic District Selector
        LocationSelectorField(
          label: l10n.districtLabel,
          value: provider.selectedDistrict,
          hintText: 'Select District in ${provider.selectedState}',
          icon: Icons.location_city_rounded,
          isRequired: true,
          onTap: () async {
            final districts = provider.availableDistricts;
            final chosen = await showSearchableLocationPicker(
              context,
              title: '${l10n.districtLabel} (${provider.selectedState})',
              searchHint: 'Search district in ${provider.selectedState}...',
              items: districts,
              selectedItem: provider.selectedDistrict,
            );
            if (chosen != null) {
              provider.setDistrictSelection(chosen);
            }
          },
        ),
        const SizedBox(height: 16),

        // Optional Village / Taluka / Block
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
            border: Border.all(color: DesignTokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.cottage_outlined, size: 18, color: DesignTokens.slate600),
                  const SizedBox(width: 8),
                  Text(
                    'Local Area Details (Optional)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Taluka / Tehsil / Block',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: DesignTokens.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: DesignTokens.border),
                        ),
                      ),
                      style: GoogleFonts.inter(fontSize: 13),
                      onChanged: provider.setTaluka,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Village / Ward',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: DesignTokens.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: DesignTokens.border),
                        ),
                      ),
                      style: GoogleFonts.inter(fontSize: 13),
                      onChanged: provider.setVillage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Rural / Urban toggle (Pill Selector)
        Text(
          l10n.areaTypeLabel,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectionPill(
                label: l10n.rural,
                selected: provider.ruralUrban == 'rural',
                onTap: () => provider.setRuralUrban('rural'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSelectionPill(
                label: l10n.semiUrban,
                selected: provider.ruralUrban == 'semi_urban',
                onTap: () => provider.setRuralUrban('semi_urban'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSelectionPill(
                label: l10n.urban,
                selected: provider.ruralUrban == 'urban',
                onTap: () => provider.setRuralUrban('urban'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // Caste / Social Category (Pill Selector)
        Text(
          l10n.casteCategoryLabel,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Used to identify reserved scholarships, coaching fee waivers, and state quotas.',
          style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.slate600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['General', 'OBC', 'SC', 'ST', 'EWS'].map((cat) {
            return _buildSelectionPill(
              label: cat,
              selected: provider.socialCategory == cat,
              onTap: () => provider.setSocialCategory(cat),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Disabilities
        Text(
          'Do you have any disabilities?',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'This helps us find opportunities with relevant accessibility support and benefits.',
          style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.slate600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Yes', 'No', 'Prefer not to say'].map((status) {
            return _buildSelectionPill(
              label: status,
              selected: provider.disabilityStatus == status,
              onTap: () => provider.setDisabilityStatus(status),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),

        // Tribal Community / Tribe Affiliation
        RoundedCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: provider.socialCategory == 'ST' || provider.tribe.isNotEmpty
              ? DesignTokens.blushBg
              : Colors.white,
          borderColor: provider.socialCategory == 'ST' || provider.tribe.isNotEmpty
              ? DesignTokens.blushBorder
              : DesignTokens.border,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.diversity_3_rounded,
                    size: 20,
                    color: DesignTokens.maroon900,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tribe / Indigenous Community (Optional)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                  ),
                  if (provider.tribe.isNotEmpty)
                    InkWell(
                      onTap: () => provider.setTribe(''),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Clear',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: DesignTokens.maroon900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Crucial for Ministry of Tribal Affairs (MoTA), Eklavya, and PVTG schemes.',
                style: GoogleFonts.inter(fontSize: 12, color: DesignTokens.slate600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  'Bhil',
                  'Gond',
                  'Santhal',
                  'Munda',
                  'Oraon',
                  'Bodo',
                  'Warli',
                  'Khasi',
                  'Garo',
                  'PVTG',
                ].map((t) {
                  final isSel = provider.tribe.toLowerCase() == t.toLowerCase();
                  return ChoiceChip(
                    label: Text(t),
                    selected: isSel,
                    selectedColor: DesignTokens.maroon900,
                    backgroundColor: Colors.white,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      color: isSel ? Colors.white : DesignTokens.slate600,
                    ),
                    side: BorderSide(
                      color: isSel ? DesignTokens.maroon900 : DesignTokens.border,
                    ),
                    onSelected: (sel) {
                      provider.setTribe(sel ? t : '');
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: provider.tribe,
                key: ValueKey(provider.tribe),
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Or enter custom tribe / PVTG name...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
                  prefixIcon: const Icon(Icons.edit_outlined, size: 18, color: DesignTokens.slate600),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                    borderSide: const BorderSide(color: DesignTokens.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                    borderSide: const BorderSide(color: DesignTokens.border),
                  ),
                ),
                onChanged: provider.setTribe,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Family Income Bracket
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.incomeBracketLabel,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: provider.familyIncome <= 25000
                    ? DesignTokens.sageBg
                    : DesignTokens.blushBg,
                borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                border: Border.all(
                  color: provider.familyIncome <= 25000
                      ? DesignTokens.sageBorder
                      : DesignTokens.blushBorder,
                ),
              ),
              child: Text(
                provider.familyIncome == 0
                    ? '₹0 (Nil Income)'
                    : provider.familyIncome <= 25000
                        ? '₹${provider.familyIncome.toStringAsFixed(0)} (Under ₹25k)'
                        : '₹${(provider.familyIncome / 1000).toStringAsFixed(0)}k / year',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: provider.familyIncome <= 25000
                      ? DesignTokens.sageText
                      : DesignTokens.maroon900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Quick one-tap income pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildIncomePill('₹0 (Nil)', 0, provider),
              const SizedBox(width: 8),
              _buildIncomePill('< ₹25,000', 25000, provider),
              const SizedBox(width: 8),
              _buildIncomePill('₹1 Lakh', 100000, provider),
              const SizedBox(width: 8),
              _buildIncomePill('₹2.5 Lakh', 250000, provider),
              const SizedBox(width: 8),
              _buildIncomePill('₹5 Lakh+', 500000, provider),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: provider.familyIncome,
          min: 0,
          max: 800000,
          divisions: 32,
          activeColor: DesignTokens.maroon900,
          inactiveColor: DesignTokens.blush200,
          label: provider.familyIncome == 0
              ? '₹0 (Nil)'
              : '₹${(provider.familyIncome / 1000).round()}k',
          onChanged: provider.setFamilyIncome,
        ),
        if (provider.familyIncome <= 25000)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: DesignTokens.sageBg,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              border: Border.all(color: DesignTokens.sageBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, size: 18, color: DesignTokens.sageText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '100% Free Tuition & Maximum Need-Based Aid qualify under ₹25k income.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.sageText,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            'Income under ₹2.5L qualifies for maximum need-based financial aid.',
            style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.slate600),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Education & Practical Learning
  // ---------------------------------------------------------------------------
  Widget _buildStep2Education(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final levels = [
      {'val': 'primary', 'label': 'Primary School (Up to 5th)'},
      {'val': 'upper_primary', 'label': 'Middle School (6th - 8th)'},
      {'val': 'secondary', 'label': '10th Pass (Secondary)'},
      {'val': 'senior_secondary', 'label': '12th Pass (Higher Secondary)'},
      {'val': 'diploma', 'label': 'Diploma / Polytechnic'},
      {'val': 'vocational', 'label': 'Vocational / ITI'},
      {'val': 'bachelor', 'label': 'Bachelor\'s Degree (Undergraduate)'},
      {'val': 'master', 'label': 'Master\'s Degree (Postgraduate)'},
      {'val': 'informal', 'label': 'Informal / Practical Learning'},
      {'val': 'self_learning', 'label': 'Self-Taught'},
      {'val': 'other', 'label': 'Other Learning Path'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stepEducation,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We value what you can actually do! Describe both formal education and practical skills learned at home or work.',
          style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 24),

        // Education Level Dropdown
        Text(
          '${l10n.educationLevelLabel} *',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
            border: Border.all(color: DesignTokens.border),
            boxShadow: DesignTokens.softShadow,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: levels.any((l) => l['val'] == provider.educationLevel)
                  ? provider.educationLevel
                  : 'secondary',
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: DesignTokens.slate600),
              items: levels.map((lvl) {
                return DropdownMenuItem<String>(
                  value: lvl['val'],
                  child: Text(lvl['label']!, style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textPrimary)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) provider.setEducationLevel(val);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Free-text practical learning
        Text(
          'Explain what you\'ve learned (Informal / Practical)',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'e.g. Worked at family workshop, repaired solar equipment, farm budgeting, computer basics...',
          style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.slate600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.informalLearningDescription,
          maxLines: 4,
          onChanged: provider.setInformalLearning,
          decoration: const InputDecoration(
            hintText: 'Describe your hands-on experience or what you know how to build or fix...',
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3: Skills & Interests Multi-Select
  // ---------------------------------------------------------------------------
  Widget _buildStep3SkillsAndInterests(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.skillsTitle} & ${l10n.interestsTitle}',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select the skills you possess and fields you find exciting. We use these to map your career pathways.',
          style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 24),

        // Skills Chips
        Text(
          l10n.skillsTitle,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: provider.skills.map((skill) {
            final isSelected = provider.selectedSkillIds.contains(skill.id);
            return _buildChip(
              label: skill.canonicalName,
              selected: isSelected,
              onTap: () => provider.toggleSkill(skill.id),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),

        // Interests Chips
        Text(
          l10n.interestsTitle,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: provider.interests.map((interest) {
            final isSelected = provider.selectedInterestIds.contains(interest.id);
            return _buildChip(
              label: interest.name,
              selected: isSelected,
              onTap: () => provider.toggleInterest(interest.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4: Aspirations (Dream Job)
  // ---------------------------------------------------------------------------
  Widget _buildStep4Aspirations(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aspirationLabel,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'What is your dream job, ambition, or career goal? Dream big — we will help connect the stepping stones.',
          style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 24),

        TextFormField(
          initialValue: provider.aspirationText,
          maxLines: 3,
          onChanged: provider.setAspirationText,
          decoration: InputDecoration(
            hintText: l10n.aspirationHint,
            prefixIcon: const Icon(Icons.star_outline_rounded, color: DesignTokens.slate600, size: 22),
          ),
        ),
        const SizedBox(height: 24),

        // Stat preview card
        const StatBlock(
          stat: '38+ Opportunities',
          label: 'Ready to be matched deterministically against your new profile.',
          variant: StatBlockVariant.mint,
          icon: Icons.verified_outlined,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Sticky CTA (Full-Width Maroon Pill)
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav(BuildContext context, OnboardingProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final isLastStep = provider.currentStep == provider.totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8)),
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.maroon900.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.errorMessage != null) ...[
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
          ElevatedButton(
            onPressed: provider.isSubmitting
                ? null
                : () async {
                    if (isLastStep) {
                      final success = await provider.submitProfile();
                      if (success && context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainShell()),
                        );
                      }
                    } else {
                      if (provider.currentStep == 0 && provider.name.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${l10n.fullNameLabel} *')),
                        );
                        return;
                      }
                      provider.nextStep();
                    }
                  },
            child: provider.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    isLastStep ? l10n.btnFinish : l10n.btnNext,
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionPill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? DesignTokens.maroon900 : Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: selected ? DesignTokens.maroon900 : DesignTokens.border,
                width: 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: DesignTokens.maroon900.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: DesignTokens.maroon900.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : DesignTokens.slate600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? DesignTokens.maroon900 : Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            constraints: const BoxConstraints(minHeight: 42.0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: selected ? DesignTokens.maroon900 : DesignTokens.border,
                width: 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: DesignTokens.maroon900.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? Colors.white : DesignTokens.slate600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomePill(String label, double val, OnboardingProvider provider) {
    final isSelected = (provider.familyIncome == val);
    return InkWell(
      onTap: () => provider.setFamilyIncome(val),
      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.maroon900 : Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          border: Border.all(
            color: isSelected ? DesignTokens.maroon900 : DesignTokens.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : DesignTokens.slate600,
          ),
        ),
      ),
    );
  }
}
