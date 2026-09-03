import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sensitivity_notice.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepEconomicContext extends ConsumerStatefulWidget {
  const StepEconomicContext({super.key});

  @override
  ConsumerState<StepEconomicContext> createState() => _StepEconomicContextState();
}

class _StepEconomicContextState extends ConsumerState<StepEconomicContext> {
  String _selectedIncome = '';
  String _selectedCaste = '';
  bool _isFirstGen = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingStateProvider).draft;
    _selectedIncome = draft.incomeBracket.isNotEmpty ? draft.incomeBracket : '< ₹1,00,000 / year';
    _selectedCaste = draft.casteCategory.isNotEmpty ? draft.casteCategory : 'OBC';
    _isFirstGen = draft.isFirstGenLearner;
  }

  void _notifyChange() {
    ref.read(onboardingStateProvider.notifier).updateEconomicContext(
          incomeBracket: _selectedIncome,
          casteCategory: _selectedCaste,
          isFirstGenLearner: _isFirstGen,
        );
  }

  void _showWhyWeAskDialog(BuildContext context, String title, String explanation) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppTheme.accentGreen),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(explanation, style: const TextStyle(fontSize: 15, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnboardingState>(onboardingStateProvider, (prev, next) {
      if (prev?.draft != next.draft) {
        if (_selectedIncome != next.draft.incomeBracket && next.draft.incomeBracket.isNotEmpty) {
          setState(() => _selectedIncome = next.draft.incomeBracket);
        }
        if (_selectedCaste != next.draft.casteCategory && next.draft.casteCategory.isNotEmpty) {
          setState(() => _selectedCaste = next.draft.casteCategory);
        }
        if (_isFirstGen != next.draft.isFirstGenLearner) {
          setState(() => _isFirstGen = next.draft.isFirstGenLearner);
        }
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final options = ref.watch(academicOptionsProvider);
    final incomeBrackets = options.getIncomeBrackets();
    final casteCategories = options.getCasteCategories();


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.economicContextTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.economicContextSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),

          // Prominent Privacy / Sensitivity notice
          SensitivityNotice(
            customReason: l10n.casteWhyWeAsk,
          ),
          const SizedBox(height: 16),

          // 1. Income Bracket
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.fieldIncomeBracket,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 22),
                tooltip: l10n.whyWeAskTitle,
                onPressed: () => _showWhyWeAskDialog(
                  context,
                  l10n.fieldIncomeBracket,
                  l10n.incomeWhyWeAsk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: incomeBrackets.map((bracket) {
              final isSelected = _selectedIncome == bracket;
              return ChoiceChip(
                key: Key('income_chip_$bracket'),
                label: Text(bracket, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedIncome = bracket);
                    _notifyChange();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 2. Caste Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.fieldCasteCategory,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 22),
                tooltip: l10n.whyWeAskTitle,
                onPressed: () => _showWhyWeAskDialog(
                  context,
                  l10n.fieldCasteCategory,
                  l10n.casteWhyWeAsk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: casteCategories.map((caste) {
              final isSelected = _selectedCaste == caste;
              return ChoiceChip(
                key: Key('caste_chip_$caste'),
                label: Text(caste, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedCaste = caste);
                    _notifyChange();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 3. First-Generation Learner Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fieldFirstGenLearner,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.firstGenLearnerDesc,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 22),
                tooltip: l10n.whyWeAskTitle,
                onPressed: () => _showWhyWeAskDialog(
                  context,
                  l10n.fieldFirstGenLearner,
                  l10n.firstGenWhyWeAsk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ChoiceChip(
                key: const Key('first_gen_yes_chip'),
                avatar: Icon(
                  _isFirstGen ? Icons.check_circle : Icons.school_outlined,
                  size: 18,
                  color: _isFirstGen ? Colors.white : AppTheme.primaryBlue,
                ),
                label: Text(l10n.firstGenYes),
                selected: _isFirstGen,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _isFirstGen = true);
                    _notifyChange();
                  }
                },
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                key: const Key('first_gen_no_chip'),
                label: Text(l10n.firstGenNo),
                selected: !_isFirstGen,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _isFirstGen = false);
                    _notifyChange();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
