import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepAspirations extends ConsumerStatefulWidget {
  const StepAspirations({super.key});

  @override
  ConsumerState<StepAspirations> createState() => _StepAspirationsState();
}

class _StepAspirationsState extends ConsumerState<StepAspirations> {
  late TextEditingController _aspirationController;
  final Set<String> _selectedPrompts = {};

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingStateProvider).draft;
    _aspirationController = TextEditingController(text: draft.aspirationText);
    _selectedPrompts.addAll(draft.selectedAspirationPrompts);
  }

  @override
  void dispose() {
    _aspirationController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    ref.read(onboardingStateProvider.notifier).updateAspirations(
          aspirationText: _aspirationController.text.trim(),
          selectedAspirationPrompts: _selectedPrompts.toList(),
        );
  }

  void _togglePrompt(String prompt) {
    setState(() {
      if (_selectedPrompts.contains(prompt)) {
        _selectedPrompts.remove(prompt);
      } else {
        _selectedPrompts.add(prompt);
        // If text input is empty, prefill with prompt
        if (_aspirationController.text.trim().isEmpty) {
          _aspirationController.text = prompt;
        } else if (!_aspirationController.text.contains(prompt)) {
          _aspirationController.text = '${_aspirationController.text.trim()}, $prompt';
        }
      }
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = ref.watch(academicOptionsProvider);
    final prompts = options.getAspirationPrompts();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.aspirationsTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.aspirationsSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Open text input field
          Text(
            l10n.aspirationsPrompt,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('aspiration_text_input'),
            controller: _aspirationController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.aspirationsHint,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.stars_rounded, color: AppTheme.secondaryAmber),
              ),
            ),
            onChanged: (_) => _notifyChange(),
          ),
          const SizedBox(height: 24),

          // Suggestion Chips Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.secondaryAmber.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, color: AppTheme.secondaryAmber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.aspirationSuggestionsTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryAmber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: prompts.map((prompt) {
                    final isSelected = _selectedPrompts.contains(prompt);
                    return ActionChip(
                      key: Key('aspiration_chip_$prompt'),
                      avatar: Icon(
                        isSelected ? Icons.check : Icons.add_circle_outline,
                        size: 16,
                        color: isSelected ? Colors.white : AppTheme.secondaryAmber,
                      ),
                      backgroundColor: isSelected ? AppTheme.secondaryAmber : Colors.white,
                      label: Text(
                        prompt,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () => _togglePrompt(prompt),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
