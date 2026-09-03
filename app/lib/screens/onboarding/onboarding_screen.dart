import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/reference.dart';
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
                      style: TextStyle(fontSize: 16, color: DesignTokens.textSecondary),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: _buildStepContent(context, provider),
                  ),
                ),

                // Bottom Action Button (Max 1 Primary CTA per screen)
                _buildBottomNav(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingProvider provider) {
    final stepTitles = [
      'Basic Details',
      'Location & Background',
      'Education & Practical Learning',
      'Skills & Interests',
      'Your Aspirations',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8))),
      ),
      child: Row(
        children: [
          ProgressRing(
            progress: provider.stepProgress,
            size: 52,
            strokeWidth: 5,
            showPercentage: true,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${provider.currentStep + 1} of ${provider.totalSteps}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.primary,
                  ),
                ),
                Text(
                  stepTitles[provider.currentStep],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (provider.currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: provider.prevStep,
              tooltip: 'Previous step',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s build your future path 🚀',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in a few details so we can find scholarships, courses, and jobs made for you.',
          style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
        ),
        const SizedBox(height: 24),

        // Full Name
        Text(
          'Your Full Name *',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.name,
          onChanged: provider.setName,
          decoration: const InputDecoration(
            hintText: 'e.g. Aarav Sharma',
            prefixIcon: Icon(Icons.person_outline_rounded, color: DesignTokens.textMuted),
          ),
        ),
        const SizedBox(height: 20),

        // Phone Number
        Text(
          'Phone Number (for SMS alerts)',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: provider.phone,
          keyboardType: TextInputType.phone,
          onChanged: provider.setPhone,
          decoration: const InputDecoration(
            hintText: '+91 98765 43210',
            prefixIcon: Icon(Icons.phone_outlined, color: DesignTokens.textMuted),
          ),
        ),
        const SizedBox(height: 20),

        // Preferred Language
        Text(
          'Preferred Language',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
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
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: effectiveLang,
                  hint: const Text('Select your preferred language'),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: langList.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang.code,
                      child: Text(
                        '${lang.name} (${lang.nativeName})',
                        style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textPrimary),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where are you located?',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Many government scholarships are reserved for specific states, districts, and rural regions.',
          style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
        ),
        const SizedBox(height: 24),

        // Location Selector from Catalogue
        Text(
          'Select Your Village / District *',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final uniqueLocs = <String, LocationItem>{};
            for (final loc in provider.locations) {
              uniqueLocs[loc.id] = loc;
            }
            final locList = uniqueLocs.values.toList();
            final currentId = provider.selectedLocationId;
            final effectiveId = uniqueLocs.containsKey(currentId)
                ? currentId
                : (locList.isNotEmpty ? locList.first.id : null);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                border: Border.all(color: DesignTokens.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: effectiveId,
                  hint: const Text('Select your village or district'),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: locList.map((loc) {
                    return DropdownMenuItem<String>(
                      value: loc.id,
                      child: Text(
                        loc.displayName,
                        style: GoogleFonts.inter(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (id) {
                    if (id != null) provider.setLocationId(id);
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        // Rural / Urban toggle
        Text(
          'Area Classification',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSelectionPill(
              label: 'Rural',
              selected: provider.ruralUrban == 'rural',
              onTap: () => provider.setRuralUrban('rural'),
            ),
            const SizedBox(width: 12),
            _buildSelectionPill(
              label: 'Semi-Urban',
              selected: provider.ruralUrban == 'semi_urban',
              onTap: () => provider.setRuralUrban('semi_urban'),
            ),
            const SizedBox(width: 12),
            _buildSelectionPill(
              label: 'Urban',
              selected: provider.ruralUrban == 'urban',
              onTap: () => provider.setRuralUrban('urban'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Caste / Social Category
        Text(
          'Social Category & Caste (for quota eligibility)',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Used to identify reserved scholarships, coaching fee waivers, and state quotas.',
          style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textSecondary),
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
        const SizedBox(height: 16),

        // Tribal Community / Tribe Affiliation
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: provider.socialCategory == 'ST' || provider.tribe.isNotEmpty
                ? DesignTokens.primaryLight
                : Colors.white,
            borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
            border: Border.all(
              color: provider.socialCategory == 'ST' || provider.tribe.isNotEmpty
                  ? DesignTokens.primary.withValues(alpha: 0.5)
                  : DesignTokens.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.diversity_3_rounded,
                    size: 20,
                    color: DesignTokens.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tribe / Indigenous Community (Optional)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                          style: GoogleFonts.inter(fontSize: 12, color: DesignTokens.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Crucial for Ministry of Tribal Affairs (MoTA), Eklavya, and PVTG schemes.',
                style: GoogleFonts.inter(fontSize: 12, color: DesignTokens.textSecondary),
              ),
              const SizedBox(height: 10),
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
                    selectedColor: DesignTokens.primary,
                    backgroundColor: Colors.white,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      color: isSel ? Colors.white : DesignTokens.textPrimary,
                    ),
                    side: BorderSide(
                      color: isSel ? DesignTokens.primary : DesignTokens.border,
                    ),
                    onSelected: (sel) {
                      provider.setTribe(sel ? t : '');
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: provider.tribe,
                key: ValueKey(provider.tribe),
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Or enter custom tribe / PVTG name...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
                  prefixIcon: const Icon(Icons.edit_outlined, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                    borderSide: BorderSide(color: DesignTokens.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                    borderSide: BorderSide(color: DesignTokens.border),
                  ),
                ),
                onChanged: provider.setTribe,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Family Income Bracket
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Annual Family Income',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: provider.familyIncome <= 25000
                    ? DesignTokens.mintBg
                    : DesignTokens.primaryLight,
                borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
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
                      ? DesignTokens.mintText
                      : DesignTokens.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 4),
        Slider(
          value: provider.familyIncome,
          min: 0,
          max: 800000,
          divisions: 32,
          activeColor: DesignTokens.primary,
          label: provider.familyIncome == 0
              ? '₹0 (Nil)'
              : '₹${(provider.familyIncome / 1000).round()}k',
          onChanged: provider.setFamilyIncome,
        ),
        if (provider.familyIncome <= 25000)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: DesignTokens.mintBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DesignTokens.mintText.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, size: 18, color: DesignTokens.mintText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '100% Free Tuition & Maximum Need-Based Aid qualify under ₹25k income.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.mintText,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            'Income under ₹2.5L qualifies for maximum need-based financial aid.',
            style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Education & Practical Learning
  // ---------------------------------------------------------------------------
  Widget _buildStep2Education(BuildContext context, OnboardingProvider provider) {
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
          'Your Education & Learning',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We value what you can actually do! Describe both formal education and practical skills learned at home or work.',
          style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
        ),
        const SizedBox(height: 24),

        // Education Level Dropdown
        Text(
          'Highest Education Level *',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
            border: Border.all(color: DesignTokens.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: levels.any((l) => l['val'] == provider.educationLevel)
                  ? provider.educationLevel
                  : 'secondary',
              items: levels.map((lvl) {
                return DropdownMenuItem<String>(
                  value: lvl['val'],
                  child: Text(lvl['label']!, style: GoogleFonts.inter(fontSize: 16)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) provider.setEducationLevel(val);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Free-text practical learning (Crucial for rural students)
        Text(
          'Explain what you\'ve learned (Informal / Practical)',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'e.g. Worked at family workshop, repaired solar equipment, farm budgeting, computer basics...',
          style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills & Interests',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the skills you possess and fields you find exciting. We use these to map your career pathways.',
          style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
        ),
        const SizedBox(height: 24),

        // Skills Chips
        Text(
          'Skills You Have (Tap to select)',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
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
          'Fields You Want to Explore',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Ambition & Dream 🎯',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What is your dream job, ambition, or career goal? Dream big — we will help connect the stepping stones.',
          style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textSecondary),
        ),
        const SizedBox(height: 24),

        TextFormField(
          initialValue: provider.aspirationText,
          maxLines: 3,
          onChanged: provider.setAspirationText,
          decoration: const InputDecoration(
            hintText: 'e.g. Agricultural Drone Pilot, Renewable Energy Technician, Government Officer...',
            prefixIcon: Icon(Icons.star_outline_rounded, color: DesignTokens.primary),
          ),
        ),
        const SizedBox(height: 24),

        // Stat preview card
        StatBlock(
          stat: '38+ Opportunities',
          label: 'Ready to be matched deterministically against your new profile.',
          variant: StatBlockVariant.mint,
          icon: Icons.verified_outlined,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Navigation (1 Primary Action Button)
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav(BuildContext context, OnboardingProvider provider) {
    final isLastStep = provider.currentStep == provider.totalSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: DesignTokens.border.withValues(alpha: 0.8))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.errorMessage != null) ...[
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
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
                          const SnackBar(content: Text('Please enter your full name')),
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
                : Text(isLastStep ? 'Complete Profile & View Matches' : 'Continue'),
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
        color: selected ? DesignTokens.primary : Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            constraints: const BoxConstraints(minHeight: DesignTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: selected ? DesignTokens.primary : DesignTokens.border,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? Colors.white : DesignTokens.textPrimary,
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
        color: selected ? DesignTokens.primary : Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            constraints: const BoxConstraints(minHeight: DesignTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: selected ? DesignTokens.primary : DesignTokens.border,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? Colors.white : DesignTokens.textPrimary,
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
          color: isSelected ? DesignTokens.primary : Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          border: Border.all(
            color: isSelected ? DesignTokens.primary : DesignTokens.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : DesignTokens.textPrimary,
          ),
        ),
      ),
    );
  }
}
