import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api_client.dart';
import '../data/models/student.dart';

class AuthProvider extends ChangeNotifier {
  final DreamCatcherApiClient _apiClient;
  StudentProfile? _currentStudent;
  bool _isLoading = true;
  String? _errorMessage;

  AuthProvider(this._apiClient) {
    _loadPersistedSession();
  }

  StudentProfile? get currentStudent => _currentStudent;
  bool get isAuthenticated => _currentStudent != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String _prefStudentIdKey = 'dreamcatcher_active_student_id';

  Future<void> _loadPersistedSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_prefStudentIdKey);
      if (savedId != null && savedId.isNotEmpty) {
        debugPrint('Found saved student session ID: $savedId');
        try {
          _currentStudent = await _apiClient.getStudent(savedId);
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

  Future<void> setCurrentStudent(StudentProfile student) async {
    _currentStudent = student;
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
