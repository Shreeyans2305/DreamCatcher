import 'package:flutter/foundation.dart';
import '../data/api_client.dart';
import '../data/models/reference.dart';
import 'auth_provider.dart';

class OnboardingProvider extends ChangeNotifier {
  final DreamCatcherApiClient _apiClient;
  final AuthProvider _authProvider;

  int _currentStep = 0;
  final int totalSteps = 5;

  // Form Fields
  String _name = '';
  String _phone = '';
  String _preferredLanguage = 'en';
  
  String? _selectedLocationId;
  LocationItem? _selectedLocation;
  String _ruralUrban = 'rural';
  String _socialCategory = 'General';
  String _tribe = '';
  String _disabilityStatus = 'Prefer not to say';
  double _familyIncome = 0;

  String _educationLevel = 'secondary';
  String _informalLearningDescription = '';

  final Set<String> _selectedSkillIds = {};
  final Set<String> _selectedInterestIds = {};
  String _aspirationText = '';

  // Catalogues
  List<Language> _languages = Language.defaultLanguages;
  List<LocationItem> _locations = LocationItem.defaultLocations;
  List<SkillItem> _skills = SkillItem.defaultSkills;
  List<InterestItem> _interests = InterestItem.defaultInterests;

  bool _isLoadingCatalogues = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  OnboardingProvider(this._apiClient, this._authProvider) {
    _selectedLocationId = _locations.isNotEmpty ? _locations.first.id : null;
    _selectedLocation = _locations.isNotEmpty ? _locations.first : null;
    loadCatalogues();
  }

  // Getters
  int get currentStep => _currentStep;
  double get stepProgress => (_currentStep + 1) / totalSteps;
  bool get isSubmitting => _isSubmitting;
  bool get isLoadingCatalogues => _isLoadingCatalogues;
  String? get errorMessage => _errorMessage;

  String get name => _name;
  String get phone => _phone;
  String get preferredLanguage => _preferredLanguage;
  String? get selectedLocationId =>
      _selectedLocationId ?? (_locations.isNotEmpty ? _locations.first.id : null);
  LocationItem? get selectedLocation {
    final id = selectedLocationId;
    if (id == null) return null;
    return _locations.cast<LocationItem?>().firstWhere(
          (l) => l?.id == id,
          orElse: () => _locations.isNotEmpty ? _locations.first : null,
        );
  }
  String get ruralUrban => _ruralUrban;
  String get socialCategory => _socialCategory;
  String get tribe => _tribe;
  String get disabilityStatus => _disabilityStatus;
  double get familyIncome => _familyIncome;
  String get educationLevel => _educationLevel;
  String get informalLearningDescription => _informalLearningDescription;
  Set<String> get selectedSkillIds => _selectedSkillIds;
  Set<String> get selectedInterestIds => _selectedInterestIds;
  String get aspirationText => _aspirationText;

  List<Language> get languages => _languages.isNotEmpty ? _languages : Language.defaultLanguages;
  List<LocationItem> get locations => _locations.isNotEmpty ? _locations : LocationItem.defaultLocations;
  List<SkillItem> get skills => _skills.isNotEmpty ? _skills : SkillItem.defaultSkills;
  List<InterestItem> get interests => _interests.isNotEmpty ? _interests : InterestItem.defaultInterests;

  // Setters
  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setPhone(String val) {
    _phone = val;
    notifyListeners();
  }

  void setLanguage(String val) {
    _preferredLanguage = val;
    notifyListeners();
  }

  void setLocationId(String id) {
    _selectedLocationId = id;
    final loc = _locations.cast<LocationItem?>().firstWhere((l) => l?.id == id, orElse: () => null);
    if (loc != null) {
      _selectedLocation = loc;
      if (loc.ruralUrban.isNotEmpty && loc.ruralUrban != 'unknown') {
        _ruralUrban = loc.ruralUrban;
      }
    }
    notifyListeners();
  }

  void setLocation(LocationItem? loc) {
    _selectedLocation = loc;
    _selectedLocationId = loc?.id;
    if (loc != null && loc.ruralUrban.isNotEmpty && loc.ruralUrban != 'unknown') {
      _ruralUrban = loc.ruralUrban;
    }
    notifyListeners();
  }

  void setRuralUrban(String val) {
    _ruralUrban = val;
    notifyListeners();
  }

  void setSocialCategory(String val) {
    _socialCategory = val;
    notifyListeners();
  }

  void setTribe(String val) {
    _tribe = val;
    notifyListeners();
  }

  void setDisabilityStatus(String val) {
    _disabilityStatus = val;
    notifyListeners();
  }

  void setFamilyIncome(double val) {
    _familyIncome = val;
    notifyListeners();
  }

  void setEducationLevel(String val) {
    _educationLevel = val;
    notifyListeners();
  }

  void setInformalLearning(String val) {
    _informalLearningDescription = val;
    notifyListeners();
  }

  void toggleSkill(String skillId) {
    if (_selectedSkillIds.contains(skillId)) {
      _selectedSkillIds.remove(skillId);
    } else {
      _selectedSkillIds.add(skillId);
    }
    notifyListeners();
  }

  void toggleInterest(String interestId) {
    if (_selectedInterestIds.contains(interestId)) {
      _selectedInterestIds.remove(interestId);
    } else {
      _selectedInterestIds.add(interestId);
    }
    notifyListeners();
  }

  void setAspirationText(String val) {
    _aspirationText = val;
    notifyListeners();
  }

  // Navigation
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> loadCatalogues() async {
    _isLoadingCatalogues = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _apiClient.fetchLanguages().catchError((_) => <Language>[]),
        _apiClient.fetchLocations(pageSize: 30).catchError((_) => <LocationItem>[]),
        _apiClient.fetchSkills(pageSize: 30).catchError((_) => <SkillItem>[]),
        _apiClient.fetchInterests(pageSize: 30).catchError((_) => <InterestItem>[]),
      ]);

      final remoteLangs = results[0] as List<Language>;
      if (remoteLangs.isNotEmpty) {
        _languages = remoteLangs;
      }
      _locations = results[1] as List<LocationItem>;
      _skills = results[2] as List<SkillItem>;
      _interests = results[3] as List<InterestItem>;

      if (_locations.isNotEmpty && _selectedLocation == null) {
        _selectedLocation = _locations.first;
      }
    } catch (e) {
      debugPrint('Error loading reference catalogues: $e');
    } finally {
      _isLoadingCatalogues = false;
      notifyListeners();
    }
  }

  static final _uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

  Future<bool> submitProfile() async {
    if (_name.trim().isEmpty) {
      _errorMessage = 'Please enter your name';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final locId = selectedLocationId;
      final validLocId = (locId != null && _uuidRegex.hasMatch(locId)) ? locId : null;

      // 1. Create Student
      final student = await _apiClient.createStudent(
        name: _name.trim(),
        phone: _phone.trim().isNotEmpty ? _phone.trim() : null,
        locationId: validLocId,
        preferredLanguage: _preferredLanguage,
      );

      // 2. Add Education Record (formal + informal learning description + real demographics)
      final demographicsPayload = [
        'Category: $_socialCategory',
        if (_tribe.isNotEmpty) 'Tribe: $_tribe',
        'Disability: $_disabilityStatus',
        'Income: ₹${_familyIncome.toInt()}',
        'Area: $_ruralUrban',
        if (_informalLearningDescription.trim().isNotEmpty)
          'Practical Learning: ${_informalLearningDescription.trim()}',
      ].join(' | ');

      try {
        await _apiClient.addStudentEducation(
          student.id,
          educationLevel: _educationLevel,
          description: demographicsPayload,
        );
      } catch (e) {
        debugPrint('Error adding education: $e');
      }

      // 3. Link Skills
      for (final skillId in _selectedSkillIds) {
        if (_uuidRegex.hasMatch(skillId)) {
          try {
            await _apiClient.addStudentSkill(student.id, skillId: skillId);
          } catch (e) {
            debugPrint('Error adding skill $skillId: $e');
          }
        }
      }

      // 4. Link Interests
      for (final interestId in _selectedInterestIds) {
        if (_uuidRegex.hasMatch(interestId)) {
          try {
            await _apiClient.addStudentInterest(student.id, interestId: interestId);
          } catch (e) {
            debugPrint('Error adding interest $interestId: $e');
          }
        }
      }

      // 5. Add Aspiration if provided
      if (_aspirationText.trim().isNotEmpty) {
        try {
          await _apiClient.addStudentAspiration(student.id, aspirationText: _aspirationText.trim());
        } catch (e) {
          debugPrint('Error adding aspiration: $e');
        }
      }

      // 6. Fetch the updated full detail profile with calculated completeness
      final fullProfile = await _apiClient.getStudent(student.id);

      // 7. Store in AuthProvider
      await _authProvider.setCurrentStudent(fullProfile);
      await _authProvider.updateDemographics(
        socialCategory: _socialCategory,
        tribe: _tribe,
        disabilityStatus: _disabilityStatus,
        familyIncome: _familyIncome,
        ruralUrban: _ruralUrban,
      );

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit profile: $e';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
