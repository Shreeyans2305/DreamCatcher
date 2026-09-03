import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api_client.dart';
import '../data/models/student.dart';

class AuthProvider extends ChangeNotifier {
  final DreamCatcherApiClient _apiClient;
  StudentProfile? _currentStudent;
  bool _isLoading = true;
  String? _errorMessage;

  String _socialCategory = 'General';
  String _tribe = '';
  double _familyIncome = 0;
  String _ruralUrban = 'rural';

  AuthProvider(this._apiClient) {
    _loadPersistedSession();
  }

  StudentProfile? get currentStudent => _currentStudent;
  bool get isAuthenticated => _currentStudent != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get socialCategory => _socialCategory;
  String get tribe => _tribe;
  double get familyIncome => _familyIncome;
  String get ruralUrban => _ruralUrban;

  static const String _prefStudentIdKey = 'dreamcatcher_active_student_id';
  static const String _prefCategoryKey = 'dreamcatcher_social_category';
  static const String _prefTribeKey = 'dreamcatcher_tribe';
  static const String _prefIncomeKey = 'dreamcatcher_family_income';
  static const String _prefRuralUrbanKey = 'dreamcatcher_rural_urban';

  void _parseDemographicsFromStudent(StudentProfile student) {
    if (student.educationRecords.isNotEmpty) {
      final desc = student.educationRecords.first.description ?? '';
      final catMatch = RegExp(r'Category:\s*([A-Za-z]+)').firstMatch(desc);
      if (catMatch != null) {
        _socialCategory = catMatch.group(1)!;
      }
      final tribeMatch = RegExp(r'Tribe:\s*([^|]+)').firstMatch(desc);
      if (tribeMatch != null) {
        final t = tribeMatch.group(1)!.trim();
        if (t.toLowerCase() != 'none') _tribe = t;
      }
      final incMatch = RegExp(r'Income:\s*₹?([0-9.]+)').firstMatch(desc);
      if (incMatch != null) {
        _familyIncome = double.tryParse(incMatch.group(1)!) ?? _familyIncome;
      }
      final areaMatch = RegExp(r'Area:\s*([A-Za-z_]+)').firstMatch(desc);
      if (areaMatch != null) {
        _ruralUrban = areaMatch.group(1)!.toLowerCase();
      }
    }
  }

  Future<void> _loadPersistedSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_prefStudentIdKey);
      _socialCategory = prefs.getString(_prefCategoryKey) ?? 'General';
      _tribe = prefs.getString(_prefTribeKey) ?? '';
      _familyIncome = prefs.getDouble(_prefIncomeKey) ?? 0;
      _ruralUrban = prefs.getString(_prefRuralUrbanKey) ?? 'rural';

      if (savedId != null && savedId.isNotEmpty) {
        debugPrint('Found saved student session ID: $savedId');
        try {
          _currentStudent = await _apiClient.getStudent(savedId);
          if (_currentStudent != null) {
            _parseDemographicsFromStudent(_currentStudent!);
          }
        } catch (e) {
          debugPrint('Failed to load student from backend: $e. Session expired or wiped.');
          await prefs.remove(_prefStudentIdKey);
        }
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDemographics({
    String? socialCategory,
    String? tribe,
    double? familyIncome,
    String? ruralUrban,
  }) async {
    if (socialCategory != null) _socialCategory = socialCategory;
    if (tribe != null) _tribe = tribe;
    if (familyIncome != null) _familyIncome = familyIncome;
    if (ruralUrban != null) _ruralUrban = ruralUrban;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (socialCategory != null) await prefs.setString(_prefCategoryKey, _socialCategory);
      if (tribe != null) await prefs.setString(_prefTribeKey, _tribe);
      if (familyIncome != null) await prefs.setDouble(_prefIncomeKey, _familyIncome);
      if (ruralUrban != null) await prefs.setString(_prefRuralUrbanKey, _ruralUrban);

      // Save directly to the backend database
      if (_currentStudent != null) {
        final currentEdu = _currentStudent!.educationRecords.isNotEmpty
            ? _currentStudent!.educationRecords.first
            : null;
        final currentLevel = currentEdu?.educationLevel ?? 'secondary';
        final payload = [
          'Category: $_socialCategory',
          if (_tribe.isNotEmpty) 'Tribe: $_tribe',
          'Income: ₹${_familyIncome.toInt()}',
          'Area: $_ruralUrban',
        ].join(' | ');

        await _apiClient.addStudentEducation(
          _currentStudent!.id,
          educationLevel: currentLevel,
          description: payload,
        );
        _currentStudent = await _apiClient.getStudent(_currentStudent!.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error saving demographics: $e');
    }
  }

  Future<void> setCurrentStudent(StudentProfile student) async {
    _currentStudent = student;
    _parseDemographicsFromStudent(student);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefStudentIdKey, student.id);
    } catch (e) {
      debugPrint('Error saving student ID: $e');
    }
  }

  Future<void> refreshProfile() async {
    if (_currentStudent == null) return;
    try {
      _currentStudent = await _apiClient.getStudent(_currentStudent!.id);
      _parseDemographicsFromStudent(_currentStudent!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing profile: $e');
    }
  }

  Future<void> logout() async {
    _currentStudent = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefStudentIdKey);
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
}
