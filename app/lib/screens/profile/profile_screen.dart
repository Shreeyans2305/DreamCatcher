import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/api_client.dart';
import '../../data/models/reference.dart';
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

    if (student == null) {
      return Scaffold(
        backgroundColor: DesignTokens.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No active profile found.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
                child: const Text('Create Profile'),
              ),
            ],
          ),
        ),
      );
    }

    final education = student.educationRecords.isNotEmpty ? student.educationRecords.first : null;
    final aspiration = student.aspirations.isNotEmpty ? student.aspirations.first : null;

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        actions: [
          if (_isLoadingCatalogues)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: DesignTokens.primary),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Profile',
            onPressed: () async {
              await auth.refreshProfile();
              if (context.mounted) {
                context.read<OpportunitiesProvider>().evaluateStudentEligibility();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card with Progress Ring
            RoundedCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ProgressRing(
                    progress: student.profileCompleteness,
                    size: 68,
                    strokeWidth: 6,
                    showPercentage: true,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (student.phone != null)
                          Text(
                            student.phone!,
                            style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          student.location?.displayName ?? 'Location not set',
                          style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Demographics & Quotas Section
            _buildSectionHeader(
              title: 'Demographics & Quotas',
              onAddOrEdit: () => _showEditDemographicsDialog(context, auth),
              editLabel: 'Update',
            ),
            const SizedBox(height: 8),
            RoundedCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDemographicRow(
                    icon: Icons.badge_outlined,
                    label: 'Social Category & Caste',
                    value: auth.socialCategory,
                  ),
                  const Divider(height: 18),
                  _buildDemographicRow(
                    icon: Icons.diversity_3_outlined,
                    label: 'Tribe Affiliation',
                    value: auth.tribe.isNotEmpty ? auth.tribe : 'None specified',
                    isTribe: auth.tribe.isNotEmpty,
                  ),
                  const Divider(height: 18),
                  _buildDemographicRow(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Annual Family Income',
                    value: auth.familyIncome == 0
                        ? '₹0 (Nil Income / Under ₹25k)'
                        : auth.familyIncome <= 25000
                            ? '₹${auth.familyIncome.toStringAsFixed(0)} (Under ₹25,000)'
                            : '₹${auth.familyIncome.toStringAsFixed(0)} / year',
                    isZeroAid: auth.familyIncome <= 25000,
                  ),
                  const Divider(height: 18),
                  _buildDemographicRow(
                    icon: Icons.holiday_village_outlined,
                    label: 'Area Classification',
                    value: auth.ruralUrban.toUpperCase(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Education Section
            _buildSectionHeader(
              title: 'Education & Learning',
              onAddOrEdit: () => _showEditEducationDialog(context, auth),
              editLabel: 'Update',
            ),
            const SizedBox(height: 8),
            RoundedCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, color: DesignTokens.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        education?.educationLevel.toUpperCase() ?? 'SECONDARY (10th)',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (education?.description != null && education!.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      education.description!,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: DesignTokens.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Text(
                      'No informal or hands-on description added yet.',
                      style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Skills Section
            _buildSectionHeader(
              title: 'Skills (${student.skills.length})',
              onAddOrEdit: () => _showAddSkillDialog(context, auth),
              editLabel: '+ Add Skill',
            ),
            const SizedBox(height: 8),
            RoundedCard(
              padding: const EdgeInsets.all(16),
              child: student.skills.isEmpty
                  ? Text(
                      'No skills added yet. Tap "+ Add Skill" to link skills from our catalogue.',
                      style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: student.skills.map((s) {
                        return Chip(
                          backgroundColor: DesignTokens.primaryLight,
                          label: Text(
                            s.skill?.canonicalName ?? 'Skill',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: DesignTokens.primary,
                            ),
                          ),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // Interests Section
            _buildSectionHeader(
              title: 'Interests (${student.interests.length})',
              onAddOrEdit: () => _showAddInterestDialog(context, auth),
              editLabel: '+ Add Interest',
            ),
            const SizedBox(height: 8),
            RoundedCard(
              padding: const EdgeInsets.all(16),
              child: student.interests.isEmpty
                  ? Text(
                      'No interests added yet. Tap "+ Add Interest" to pick fields you enjoy.',
                      style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: student.interests.map((i) {
                        return Chip(
                          backgroundColor: DesignTokens.lavenderBg,
                          label: Text(
                            i.interest?.name ?? 'Interest',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: DesignTokens.lavenderText,
                            ),
                          ),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // Aspirations Section
            _buildSectionHeader(
              title: 'Career Ambition / Dream',
              onAddOrEdit: () => _showEditAspirationDialog(context, auth),
              editLabel: 'Update',
            ),
            const SizedBox(height: 8),
            RoundedCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      aspiration?.aspirationText ?? 'No aspiration added yet.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
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
                icon: const Icon(Icons.logout_rounded, color: DesignTokens.textMuted, size: 20),
                label: Text(
                  'Switch / Reset Profile',
                  style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textMuted),
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

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onAddOrEdit,
    required String editLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onAddOrEdit,
          child: Text(
            editLabel,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DesignTokens.primary,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSkillDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    if (student == null) return;

    final existingSkillIds = student.skills.map((s) => s.skillId).toSet();
    final availableSkills = _catalogueSkills.where((s) => !existingSkillIds.contains(s.id)).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Add a New Skill',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: availableSkills.isEmpty
              ? const Text('All available catalogue skills are already added!')
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
                              SnackBar(content: Text('Added skill: ${skill.canonicalName}')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error adding skill: $e')),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddInterestDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    if (student == null) return;

    final existingIds = student.interests.map((i) => i.interestId).toSet();
    final available = _catalogueInterests.where((i) => !existingIds.contains(i.id)).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Add a Field of Interest',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: available.isEmpty
              ? const Text('All available interests are already added!')
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
                              SnackBar(content: Text('Added interest: ${item.name}')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error adding interest: $e')),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditEducationDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    if (student == null) return;

    final existingEdu = student.educationRecords.isNotEmpty ? student.educationRecords.first : null;
    final textController = TextEditingController(text: existingEdu?.description ?? '');
    String selectedLevel = existingEdu?.educationLevel ?? 'secondary';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Update Education & Learning',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Education Level', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                DropdownButton<String>(
                  isExpanded: true,
                  value: const [
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
                  ].contains(selectedLevel)
                      ? selectedLevel
                      : 'secondary',
                  items: const [
                    DropdownMenuItem(value: 'primary', child: Text('Primary School (Up to 5th)')),
                    DropdownMenuItem(value: 'upper_primary', child: Text('Middle School (6th - 8th)')),
                    DropdownMenuItem(value: 'secondary', child: Text('10th Pass (Secondary)')),
                    DropdownMenuItem(value: 'senior_secondary', child: Text('12th Pass (Higher Secondary)')),
                    DropdownMenuItem(value: 'diploma', child: Text('Diploma / Polytechnic')),
                    DropdownMenuItem(value: 'vocational', child: Text('Vocational / ITI')),
                    DropdownMenuItem(value: 'bachelor', child: Text("Bachelor's Degree")),
                    DropdownMenuItem(value: 'master', child: Text("Master's Degree")),
                    DropdownMenuItem(value: 'informal', child: Text('Informal / Practical Learning')),
                    DropdownMenuItem(value: 'self_learning', child: Text('Self-Taught')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedLevel = v);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Hands-on / Informal Learning Description',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'What have you learned to do practically?',
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
                      const SnackBar(content: Text('Education details updated successfully!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating education: $e')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAspirationDialog(BuildContext context, AuthProvider auth) {
    final client = context.read<DreamCatcherApiClient>();
    final student = auth.currentStudent;
    if (student == null) return;

    final existingAsp = student.aspirations.isNotEmpty ? student.aspirations.first.aspirationText : '';
    final textController = TextEditingController(text: existingAsp);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Your Career Goal / Ambition',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: TextField(
          controller: textController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'e.g. Agricultural Drone Pilot, Electrical Contractor...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
                    const SnackBar(content: Text('Aspiration updated!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating aspiration: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
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
        Icon(icon, size: 20, color: DesignTokens.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isZeroAid
                ? DesignTokens.mintBg
                : (isTribe ? DesignTokens.primaryLight : const Color(0xFFF3F4F6)),
            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isZeroAid
                  ? DesignTokens.mintText
                  : (isTribe ? DesignTokens.primary : DesignTokens.textPrimary),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDemographicsDialog(BuildContext context, AuthProvider auth) {
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
            'Update Demographics & Quotas',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Social Category / Caste Quota', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ['General', 'OBC', 'SC', 'ST', 'EWS'].map((cat) {
                    final isSel = selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      selectedColor: DesignTokens.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : DesignTokens.textPrimary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                      onSelected: (sel) {
                        if (sel) setDialogState(() => selectedCategory = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Tribe / Community (Optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Unlocks specific Ministry of Tribal Affairs (MoTA) and PVTG programs.',
                  style: GoogleFonts.inter(fontSize: 12, color: DesignTokens.textSecondary),
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
                      selectedColor: DesignTokens.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSel ? Colors.white : DesignTokens.textPrimary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
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
                  decoration: const InputDecoration(
                    hintText: 'Or enter custom tribe / PVTG name...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (val) => selectedTribe = val,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Family Income', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                      selectedIncome == 0
                          ? '₹0 (Nil Income)'
                          : selectedIncome <= 25000
                              ? '₹${selectedIncome.toStringAsFixed(0)} (Under ₹25k)'
                              : '₹${(selectedIncome / 1000).toStringAsFixed(0)}k',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIncome <= 25000 ? DesignTokens.mintText : DesignTokens.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                  activeColor: DesignTokens.primary,
                  onChanged: (v) => setDialogState(() => selectedIncome = v),
                ),
                if (selectedIncome <= 25000)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DesignTokens.mintBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '✓ Qualifies for 100% full fee waiver and maximum need-based scholarships.',
                      style: TextStyle(fontSize: 12, color: DesignTokens.mintText, fontWeight: FontWeight.w600),
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
                final finalTribe = tribeController.text.trim();
                await auth.updateDemographics(
                  socialCategory: selectedCategory,
                  tribe: finalTribe,
                  familyIncome: selectedIncome,
                );
                if (context.mounted) {
                  context.read<OpportunitiesProvider>().evaluateStudentEligibility();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demographics & quota eligibility updated!')),
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

  Widget _buildDialogIncomePill(String label, double val, double currentVal, ValueChanged<double> onSelect) {
    final isSel = (currentVal == val);
    return InkWell(
      onTap: () => onSelect(val),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSel ? DesignTokens.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSel ? DesignTokens.primary : DesignTokens.border),
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
}
