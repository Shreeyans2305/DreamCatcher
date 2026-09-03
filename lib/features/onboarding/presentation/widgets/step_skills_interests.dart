import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepSkillsInterests extends ConsumerStatefulWidget {
  const StepSkillsInterests({super.key});

  @override
  ConsumerState<StepSkillsInterests> createState() => _StepSkillsInterestsState();
}

class _StepSkillsInterestsState extends ConsumerState<StepSkillsInterests> {
  final Set<String> _selectedSkills = {};
  final Set<String> _selectedInterests = {};
  final List<String> _customSkills = [];
  late TextEditingController _customTagController;
  late TextEditingController _freeTextInterestsController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingStateProvider).draft;
    _selectedSkills.addAll(draft.skills);
    _selectedInterests.addAll(draft.interests);
    _customSkills.addAll(draft.customSkills);
    _customTagController = TextEditingController();
    _freeTextInterestsController = TextEditingController(text: draft.freeTextInterests);
  }

  @override
  void dispose() {
    _customTagController.dispose();
    _freeTextInterestsController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    ref.read(onboardingStateProvider.notifier).updateSkillsAndInterests(
          skills: _selectedSkills.toList(),
          interests: _selectedInterests.toList(),
          customSkills: _customSkills,
          freeTextInterests: _freeTextInterestsController.text.trim(),
        );
  }

  void _addCustomTag() {
    final text = _customTagController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (!_customSkills.contains(text)) {
        _customSkills.add(text);
        _selectedSkills.add(text);
      }
      _customTagController.clear();
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = ref.watch(academicOptionsProvider);
    final commonSkills = options.getCommonSkills();
    final commonInterests = options.getCommonInterests();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.skillsInterestsTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.skillsInterestsSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // 1. Common Skills Tag Picker
          Text(
            l10n.skillsTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonSkills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return FilterChip(
                key: Key('skill_chip_$skill'),
                label: Text(skill),
                selected: isSelected,
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primaryBlue,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSkills.add(skill);
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                  _notifyChange();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Custom Tag Adder
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('custom_tag_input'),
                  controller: _customTagController,
                  decoration: InputDecoration(
                    hintText: l10n.addCustomTagHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onSubmitted: (_) => _addCustomTag(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                key: const Key('add_custom_tag_button'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: _addCustomTag,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.btnAdd),
              ),
            ],
          ),

          // Render custom chips added by student
          if (_customSkills.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _customSkills.map((tag) {
                return Chip(
                  avatar: const Icon(Icons.star, size: 16, color: AppTheme.secondaryAmber),
                  label: Text(tag, style: const TextStyle(fontWeight: FontWeight.bold)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      _customSkills.remove(tag);
                      _selectedSkills.remove(tag);
                    });
                    _notifyChange();
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 24),

          // 2. Interests Tag Picker
          Text(
            l10n.interestsTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                key: Key('interest_chip_$interest'),
                label: Text(interest),
                selected: isSelected,
                selectedColor: AppTheme.secondaryContainer,
                checkmarkColor: AppTheme.secondaryAmber,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                  _notifyChange();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 3. Free Text Hobbies & Passions
          Text(
            l10n.freeTextInterestsPrompt,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            key: const Key('free_text_interests_input'),
            controller: _freeTextInterestsController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: l10n.freeTextInterestsHint,
            ),
            onChanged: (_) => _notifyChange(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
