import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepBasicInfo extends ConsumerStatefulWidget {
  const StepBasicInfo({super.key});

  @override
  ConsumerState<StepBasicInfo> createState() => _StepBasicInfoState();
}

class _StepBasicInfoState extends ConsumerState<StepBasicInfo> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _districtController;
  String _selectedGender = '';
  String _selectedState = '';
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingStateProvider).draft;
    _nameController = TextEditingController(text: draft.name);
    _ageController = TextEditingController(text: draft.age > 0 ? draft.age.toString() : '17');
    _districtController = TextEditingController(text: draft.district);
    _selectedGender = draft.gender.isNotEmpty ? draft.gender : 'Male';
    _selectedState = draft.state.isNotEmpty ? draft.state : 'Madhya Pradesh';
    _selectedLanguage = draft.preferredLanguage.isNotEmpty ? draft.preferredLanguage : 'en';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    final age = int.tryParse(_ageController.text.trim()) ?? 17;
    ref.read(onboardingStateProvider.notifier).updateBasicInfo(
          name: _nameController.text.trim(),
          age: age,
          gender: _selectedGender,
          stateName: _selectedState,
          district: _districtController.text.trim(),
          preferredLanguage: _selectedLanguage,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnboardingState>(onboardingStateProvider, (prev, next) {
      if (prev?.draft != next.draft) {
        if (_nameController.text != next.draft.name && next.draft.name.isNotEmpty) {
          _nameController.text = next.draft.name;
        }
        final ageStr = next.draft.age > 0 ? next.draft.age.toString() : '17';
        if (_ageController.text != ageStr) {
          _ageController.text = ageStr;
        }
        if (_districtController.text != next.draft.district && next.draft.district.isNotEmpty) {
          _districtController.text = next.draft.district;
        }
        if (_selectedGender != next.draft.gender && next.draft.gender.isNotEmpty) {
          setState(() => _selectedGender = next.draft.gender);
        }
        if (_selectedState != next.draft.state && next.draft.state.isNotEmpty) {
          setState(() => _selectedState = next.draft.state);
        }
        if (_selectedLanguage != next.draft.preferredLanguage && next.draft.preferredLanguage.isNotEmpty) {
          setState(() => _selectedLanguage = next.draft.preferredLanguage);
        }
      }
    });

    final l10n = AppLocalizations.of(context)!;

    final options = ref.watch(academicOptionsProvider);
    final states = options.getIndianStates();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.basicInfoTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.basicInfoSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Name field
          Text(l10n.fieldName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          TextField(
            key: const Key('onboarding_name_input'),
            controller: _nameController,
            decoration: InputDecoration(
              hintText: l10n.fieldNameHint,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            onChanged: (_) => _notifyChange(),
          ),
          const SizedBox(height: 16),

          // Age and Gender Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.fieldAge, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 6),
                    TextField(
                      key: const Key('onboarding_age_input'),
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.fieldAgeHint,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      onChanged: (_) => _notifyChange(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.fieldLanguage, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('English'),
                          selected: _selectedLanguage == 'en',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedLanguage = 'en');
                              _notifyChange();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('हिंदी'),
                          selected: _selectedLanguage == 'hi',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedLanguage = 'hi');
                              _notifyChange();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gender selection
          Text(l10n.fieldGender, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildGenderChip(l10n.genderMale, 'Male', Icons.man),
              _buildGenderChip(l10n.genderFemale, 'Female', Icons.woman),
              _buildGenderChip(l10n.genderOther, 'Other', Icons.person),
              _buildGenderChip(l10n.genderPreferNot, 'Prefer not to say', Icons.do_not_disturb_on_outlined),
            ],
          ),
          const SizedBox(height: 20),

          // State Dropdown
          Text(l10n.fieldState, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBDBDBD), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: const Key('onboarding_state_dropdown'),
                value: states.contains(_selectedState) ? _selectedState : states.first,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedState = val);
                    _notifyChange();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // District Input
          Text(l10n.fieldDistrict, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          TextField(
            key: const Key('onboarding_district_input'),
            controller: _districtController,
            decoration: InputDecoration(
              hintText: l10n.fieldDistrictHint,
              prefixIcon: const Icon(Icons.location_city_outlined),
            ),
            onChanged: (_) => _notifyChange(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenderChip(String label, String value, IconData icon) {
    final isSelected = _selectedGender == value;
    return ChoiceChip(
      avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : AppTheme.primaryBlue),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedGender = value);
          _notifyChange();
        }
      },
    );
  }
}
