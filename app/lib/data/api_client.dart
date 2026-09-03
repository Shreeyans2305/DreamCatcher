import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'models/eligibility.dart';
import 'models/opportunity.dart';
import 'models/reference.dart';
import 'models/student.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

class DreamCatcherApiClient {
  static const String defaultBaseUrl =
      'https://dreamcatcher-backend-635980060226.asia-south1.run.app/api/v1';

  final String baseUrl;
  final http.Client _client;
  final Duration requestTimeout;

  DreamCatcherApiClient({
    String? baseUrl,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 35), // Cloud Run cold-start tolerance
  })  : baseUrl = baseUrl ??
            const String.fromEnvironment('API_BASE_URL', defaultValue: defaultBaseUrl),
        _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Uri _uri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$baseUrl$cleanPath';
    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final stringParams = queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return uri.replace(queryParameters: stringParams);
    }
    return uri;
  }

  dynamic _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : null;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    final detail = body is Map && body['detail'] != null ? body['detail'].toString() : response.reasonPhrase;
    throw ApiException(detail ?? 'Server error', response.statusCode);
  }

  Future<dynamic> _get(String path, [Map<String, dynamic>? queryParams]) async {
    try {
      final url = _uri(path, queryParams);
      debugPrint('API GET: $url');
      final response = await _client.get(url, headers: _headers).timeout(requestTimeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Connecting to server took longer than expected. Please try again.');
    } on SocketException catch (e) {
      throw ApiException('Network connection failed: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  Future<dynamic> _post(String path, dynamic body) async {
    try {
      final url = _uri(path);
      debugPrint('API POST: $url');
      final response = await _client
          .post(url, headers: _headers, body: jsonEncode(body))
          .timeout(requestTimeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Connecting to server took longer than expected. Please try again.');
    } on SocketException catch (e) {
      throw ApiException('Network connection failed: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  Future<dynamic> _put(String path, dynamic body) async {
    try {
      final url = _uri(path);
      debugPrint('API PUT: $url');
      final response = await _client
          .put(url, headers: _headers, body: jsonEncode(body))
          .timeout(requestTimeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Connecting to server took longer than expected. Please try again.');
    } on SocketException catch (e) {
      throw ApiException('Network connection failed: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // References
  // ---------------------------------------------------------------------------
  Future<List<Language>> fetchLanguages() async {
    final res = await _get('/languages', {'active_only': 'true'});
    if (res is List) {
      return res.map((e) => Language.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<LocationItem>> fetchLocations({int page = 1, int pageSize = 50}) async {
    final res = await _get('/locations', {'page': page, 'page_size': pageSize});
    if (res is Map && res['items'] is List) {
      return (res['items'] as List)
          .map((e) => LocationItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<SkillItem>> fetchSkills({int page = 1, int pageSize = 50}) async {
    final res = await _get('/skills', {'page': page, 'page_size': pageSize});
    if (res is Map && res['items'] is List) {
      return (res['items'] as List)
          .map((e) => SkillItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<InterestItem>> fetchInterests({int page = 1, int pageSize = 50}) async {
    final res = await _get('/interests', {'page': page, 'page_size': pageSize});
    if (res is Map && res['items'] is List) {
      return (res['items'] as List)
          .map((e) => InterestItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // ---------------------------------------------------------------------------
  // Students
  // ---------------------------------------------------------------------------
  Future<StudentProfile> createStudent({
    required String name,
    String? phone,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? locationId,
    String preferredLanguage = 'en',
  }) async {
    final payload = <String, dynamic>{
      'name': name,
      'preferred_language': preferredLanguage,
    };
    if (phone != null && phone.isNotEmpty) payload['phone'] = phone;
    if (email != null && email.isNotEmpty) payload['email'] = email;
    if (dateOfBirth != null) payload['date_of_birth'] = dateOfBirth;
    if (gender != null) payload['gender'] = gender;
    if (locationId != null) payload['location_id'] = locationId;

    final res = await _post('/students', payload);
    return StudentProfile.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentProfile> getStudent(String studentId) async {
    final res = await _get('/students/$studentId');
    return StudentProfile.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentProfile> updateStudent(String studentId, Map<String, dynamic> updateData) async {
    final res = await _put('/students/$studentId', updateData);
    return StudentProfile.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentEducation> addStudentEducation(
    String studentId, {
    String? institutionName,
    required String educationLevel,
    String? curriculum,
    String? board,
    String? fieldOfStudy,
    String? description,
    String status = 'completed',
  }) async {
    final payload = <String, dynamic>{
      'education_level': educationLevel,
      'status': status,
      'confidence': 1.0,
      'source': 'student_reported',
    };
    if (institutionName != null) payload['institution_name'] = institutionName;
    if (curriculum != null) payload['curriculum'] = curriculum;
    if (board != null) payload['board'] = board;
    if (fieldOfStudy != null) payload['field_of_study'] = fieldOfStudy;
    if (description != null && description.isNotEmpty) payload['description'] = description;

    final res = await _post('/students/$studentId/education', payload);
    return StudentEducation.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentSkill> addStudentSkill(
    String studentId, {
    required String skillId,
    String proficiency = 'beginner',
    double? yearsExperience,
  }) async {
    final payload = <String, dynamic>{
      'skill_id': skillId,
      'proficiency': proficiency,
      'confidence': 1.0,
      'source': 'student_reported',
    };
    if (yearsExperience != null) payload['years_experience'] = yearsExperience;
    final res = await _post('/students/$studentId/skills', payload);
    return StudentSkill.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentInterest> addStudentInterest(
    String studentId, {
    required String interestId,
    double strength = 0.8,
  }) async {
    final payload = {
      'interest_id': interestId,
      'strength': strength,
      'confidence': 1.0,
      'source': 'student_reported',
    };
    final res = await _post('/students/$studentId/interests', payload);
    return StudentInterest.fromJson(res as Map<String, dynamic>);
  }

  Future<StudentAspiration> addStudentAspiration(
    String studentId, {
    required String aspirationText,
    int priority = 1,
  }) async {
    final payload = {
      'aspiration_text': aspirationText,
      'priority': priority,
      'confidence': 1.0,
      'source': 'student_reported',
    };
    final res = await _post('/students/$studentId/aspirations', payload);
    return StudentAspiration.fromJson(res as Map<String, dynamic>);
  }

  // ---------------------------------------------------------------------------
  // Opportunities & Eligibility
  // ---------------------------------------------------------------------------
  Future<List<Opportunity>> fetchOpportunities({
    String? type,
    String? search,
    String? state,
    int page = 1,
    int pageSize = 30,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      'status': 'active',
    };
    if (type != null && type.isNotEmpty && type != 'all') query['type'] = type;
    if (search != null && search.trim().isNotEmpty) query['search'] = search.trim();
    if (state != null && state.isNotEmpty) query['state'] = state;

    final res = await _get('/opportunities', query);
    if (res is Map && res['items'] is List) {
      return (res['items'] as List)
          .map((e) => Opportunity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Opportunity> getOpportunity(String opportunityId) async {
    final res = await _get('/opportunities/$opportunityId');
    return Opportunity.fromJson(res as Map<String, dynamic>);
  }

  Future<EligibilityCheckResult> checkOpportunityEligibility(
    String opportunityId,
    Map<String, dynamic> profileDict,
  ) async {
    final res = await _post('/opportunities/$opportunityId/check-eligibility', profileDict);
    return EligibilityCheckResult.fromJson(res as Map<String, dynamic>);
  }

  Future<List<EligibilityCheckResult>> fetchEligibleOpportunities(String studentId) async {
    final res = await _get('/students/$studentId/eligible-opportunities');
    if (res is List) {
      return res
          .map((e) => EligibilityCheckResult.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
