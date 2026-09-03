import 'package:flutter/foundation.dart';
import '../data/api_client.dart';
import '../data/models/eligibility.dart';
import '../data/models/opportunity.dart';
import 'auth_provider.dart';

class OpportunitiesProvider extends ChangeNotifier {
  final DreamCatcherApiClient _apiClient;
  final AuthProvider _authProvider;

  List<Opportunity> _allOpportunities = [];
  final Map<String, EligibilityCheckResult> _eligibilityMap = {}; // oppId -> result
  
  String _selectedType = 'all'; // all, scholarship, course, entrance_exam, internship
  bool _onlyEligible = false;
  String _searchQuery = '';

  bool _isLoading = false;
  String? _errorMessage;

  OpportunitiesProvider(this._apiClient, this._authProvider) {
    fetchOpportunities();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedType => _selectedType;
  bool get onlyEligible => _onlyEligible;
  String get searchQuery => _searchQuery;

  int get totalMatchedCount => _eligibilityMap.values.where((e) => e.isEligible).length;

  List<Opportunity> get filteredOpportunities {
    return _allOpportunities.where((opp) {
      // 1. Type Filter
      if (_selectedType != 'all' && opp.type.toLowerCase() != _selectedType.toLowerCase()) {
        return false;
      }

      // 2. Eligibility Filter
      if (_onlyEligible) {
        final elig = _eligibilityMap[opp.id];
        if (elig == null || !elig.isEligible) {
          return false;
        }
      }

      // 3. Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = opp.title.toLowerCase().contains(query);
        final matchDesc = opp.description?.toLowerCase().contains(query) ?? false;
        final matchType = opp.typeLabel.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchType) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Opportunity> get topMatchedOpportunities {
    final eligibleList = _allOpportunities.where((opp) {
      final res = _eligibilityMap[opp.id];
      return res != null && res.isEligible;
    }).toList();

    if (eligibleList.isNotEmpty) {
      return eligibleList.take(5).toList();
    }
    // Fallback if no specific eligibility check passed yet: return top active items
    return _allOpportunities.take(5).toList();
  }

  void setType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setOnlyEligible(bool value) {
    _onlyEligible = value;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  EligibilityCheckResult? getEligibilityForOpportunity(String opportunityId) {
    return _eligibilityMap[opportunityId];
  }

  Future<void> fetchOpportunities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final opps = await _apiClient.fetchOpportunities(pageSize: 50);
      _allOpportunities = opps;

      // If student is logged in, evaluate eligibility
      await evaluateStudentEligibility();
    } catch (e) {
      _errorMessage = 'Failed to load opportunities: $e';
      debugPrint('Error fetching opportunities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> evaluateStudentEligibility() async {
    final student = _authProvider.currentStudent;
    if (student == null) return;

    try {
      // 1. Try fetching directly from /students/{student_id}/eligible-opportunities
      final results = await _apiClient.fetchEligibleOpportunities(student.id);
      for (final res in results) {
        _eligibilityMap[res.opportunityId] = res;
      }
    } catch (e) {
      debugPrint('Error calling fetchEligibleOpportunities: $e. Falling back to individual check.');
    }

    // 2. For any opportunities without an eligibility record, evaluate using check-eligibility
    final studentEdu = student.educationRecords.isNotEmpty ? student.educationRecords.first : null;
    final profileDict = <String, dynamic>{
      if (student.gender != null) 'gender': student.gender,
      if (student.location?.state != null) 'state': student.location!.state,
      if (student.location != null && student.location!.ruralUrban != 'unknown')
        'rural_status': student.location!.ruralUrban,
      if (studentEdu != null) 'education_level': studentEdu.educationLevel,
    };

    for (final opp in _allOpportunities) {
      if (!_eligibilityMap.containsKey(opp.id)) {
        try {
          final res = await _apiClient.checkOpportunityEligibility(opp.id, profileDict);
          _eligibilityMap[opp.id] = res;
          opp.eligibilityResult = res;
        } catch (_) {
          // No eligibility rules defined on this opportunity, or check skipped
        }
      } else {
        opp.eligibilityResult = _eligibilityMap[opp.id];
      }
    }

    notifyListeners();
  }
}
