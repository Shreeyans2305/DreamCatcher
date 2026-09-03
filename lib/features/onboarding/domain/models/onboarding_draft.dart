import 'dart:convert';
import '../../../profile/domain/models/student_profile.dart';

/// Immutable model representing the student's progress and responses across the 6-step wizard.
class OnboardingDraft {
  final String userId;
  final int currentStep;

  // Step 1: Basic Info
  final String name;
  final int age;
  final String gender;
  final String state;
  final String district;
  final String preferredLanguage;

  // Step 2: Family & Economic Context
  final String incomeBracket;
  final String casteCategory;
  final bool isFirstGenLearner;

  // Step 3: Academic Background (Structured + Unstructured)
  final bool hasFormalCurriculum;
  final String board;
  final String grade;
  final String marks;
  final String unstructuredLearning;
  final List<String> practicalSubjects;

  // Step 4: Skills & Interests
  final List<String> skills;
  final List<String> interests;
  final List<String> customSkills;
  final String freeTextInterests;

  // Step 5: Aspirations
  final String aspirationText;
  final List<String> selectedAspirationPrompts;

  // Metadata
  final bool isPendingSync;
  final DateTime? lastSavedAt;

  const OnboardingDraft({
    required this.userId,
    this.currentStep = 0,
    this.name = '',
    this.age = 17,
    this.gender = '',
    this.state = '',
    this.district = '',
    this.preferredLanguage = 'en',
    this.incomeBracket = '',
    this.casteCategory = '',
    this.isFirstGenLearner = false,
    this.hasFormalCurriculum = true,
    this.board = '',
    this.grade = '',
    this.marks = '',
    this.unstructuredLearning = '',
    this.practicalSubjects = const [],
    this.skills = const [],
    this.interests = const [],
    this.customSkills = const [],
    this.freeTextInterests = '',
    this.aspirationText = '',
    this.selectedAspirationPrompts = const [],
    this.isPendingSync = false,
    this.lastSavedAt,
  });

  OnboardingDraft copyWith({
    String? userId,
    int? currentStep,
    String? name,
    int? age,
    String? gender,
    String? state,
    String? district,
    String? preferredLanguage,
    String? incomeBracket,
    String? casteCategory,
    bool? isFirstGenLearner,
    bool? hasFormalCurriculum,
    String? board,
    String? grade,
    String? marks,
    String? unstructuredLearning,
    List<String>? practicalSubjects,
    List<String>? skills,
    List<String>? interests,
    List<String>? customSkills,
    String? freeTextInterests,
    String? aspirationText,
    List<String>? selectedAspirationPrompts,
    bool? isPendingSync,
    DateTime? lastSavedAt,
  }) {
    return OnboardingDraft(
      userId: userId ?? this.userId,
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      district: district ?? this.district,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      incomeBracket: incomeBracket ?? this.incomeBracket,
      casteCategory: casteCategory ?? this.casteCategory,
      isFirstGenLearner: isFirstGenLearner ?? this.isFirstGenLearner,
      hasFormalCurriculum: hasFormalCurriculum ?? this.hasFormalCurriculum,
      board: board ?? this.board,
      grade: grade ?? this.grade,
      marks: marks ?? this.marks,
      unstructuredLearning: unstructuredLearning ?? this.unstructuredLearning,
      practicalSubjects: practicalSubjects ?? this.practicalSubjects,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      customSkills: customSkills ?? this.customSkills,
      freeTextInterests: freeTextInterests ?? this.freeTextInterests,
      aspirationText: aspirationText ?? this.aspirationText,
      selectedAspirationPrompts:
          selectedAspirationPrompts ?? this.selectedAspirationPrompts,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
    );
  }

  /// Converts the completed wizard draft into a finalized [StudentProfile].
  StudentProfile toStudentProfile() {
    final combinedSkills = <String>{...skills, ...customSkills}.toList();
    final combinedSubjects = <String>{...practicalSubjects}.toList();
    final combinedInterests = <String>{
      ...interests,
      if (freeTextInterests.trim().isNotEmpty) freeTextInterests.trim(),
    }.toList();

    final aspirationsList = <String>[];
    if (aspirationText.trim().isNotEmpty) {
      aspirationsList.add(aspirationText.trim());
    }
    for (final prompt in selectedAspirationPrompts) {
      if (!aspirationsList.contains(prompt)) {
        aspirationsList.add(prompt);
      }
    }

    final String curriculumSummary;
    if (hasFormalCurriculum) {
      final boardPart = board.isNotEmpty ? board : 'Formal Schooling';
      final gradePart = grade.isNotEmpty ? ' ($grade)' : '';
      final marksPart = marks.isNotEmpty ? ' - $marks' : '';
      curriculumSummary = '$boardPart$gradePart$marksPart';
    } else {
      curriculumSummary = 'Practical & Self-Taught Experience';
    }

    return StudentProfile(
      id: userId,
      name: name.trim().isEmpty ? 'Student' : name.trim(),
      age: age,
      gender: gender,
      state: state,
      district: district,
      preferredLanguage: preferredLanguage,
      incomeBracket: incomeBracket.isEmpty ? '< ₹1,50,000 / year' : incomeBracket,
      casteCategory: casteCategory.isEmpty ? 'General' : casteCategory,
      isFirstGenLearner: isFirstGenLearner,
      hasFormalCurriculum: hasFormalCurriculum,
      curriculum: curriculumSummary,
      board: board,
      grade: grade,
      marks: marks,
      unstructuredLearning: unstructuredLearning,
      skills: combinedSkills,
      subjectsLearned: combinedSubjects,
      interests: combinedInterests,
      aspirations: aspirationsList,
      isPendingSync: isPendingSync,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStep': currentStep,
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
      'district': district,
      'preferredLanguage': preferredLanguage,
      'incomeBracket': incomeBracket,
      'casteCategory': casteCategory,
      'isFirstGenLearner': isFirstGenLearner,
      'hasFormalCurriculum': hasFormalCurriculum,
      'board': board,
      'grade': grade,
      'marks': marks,
      'unstructuredLearning': unstructuredLearning,
      'practicalSubjects': practicalSubjects,
      'skills': skills,
      'interests': interests,
      'customSkills': customSkills,
      'freeTextInterests': freeTextInterests,
      'aspirationText': aspirationText,
      'selectedAspirationPrompts': selectedAspirationPrompts,
      'isPendingSync': isPendingSync,
      'lastSavedAt': lastSavedAt?.toIso8601String(),
    };
  }

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    return OnboardingDraft(
      userId: json['userId'] as String? ?? '',
      currentStep: json['currentStep'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 17,
      gender: json['gender'] as String? ?? '',
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      incomeBracket: json['incomeBracket'] as String? ?? '',
      casteCategory: json['casteCategory'] as String? ?? '',
      isFirstGenLearner: json['isFirstGenLearner'] as bool? ?? false,
      hasFormalCurriculum: json['hasFormalCurriculum'] as bool? ?? true,
      board: json['board'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
      marks: json['marks'] as String? ?? '',
      unstructuredLearning: json['unstructuredLearning'] as String? ?? '',
      practicalSubjects: json['practicalSubjects'] != null
          ? List<String>.from(json['practicalSubjects'])
          : const [],
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : const [],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : const [],
      customSkills: json['customSkills'] != null
          ? List<String>.from(json['customSkills'])
          : const [],
      freeTextInterests: json['freeTextInterests'] as String? ?? '',
      aspirationText: json['aspirationText'] as String? ?? '',
      selectedAspirationPrompts: json['selectedAspirationPrompts'] != null
          ? List<String>.from(json['selectedAspirationPrompts'])
          : const [],
      isPendingSync: json['isPendingSync'] as bool? ?? false,
      lastSavedAt: json['lastSavedAt'] != null
          ? DateTime.tryParse(json['lastSavedAt'] as String)
          : null,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory OnboardingDraft.fromJsonString(String jsonStr) =>
      OnboardingDraft.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
}
