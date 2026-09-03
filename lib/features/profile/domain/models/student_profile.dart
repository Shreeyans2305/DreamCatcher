/// Represents a student profile in DreamCatcher.
/// Sensitive fields (casteCategory, incomeBracket) are safeguarded and excluded from toString logging.
class StudentProfile {

  final String id;
  final String name;
  final int age;
  final String gender;
  final String state;
  final String district;
  final String preferredLanguage;
  final String incomeBracket; // Sensitive
  final String casteCategory; // Sensitive
  final bool isFirstGenLearner;
  final bool hasFormalCurriculum;
  final String curriculum;
  final String board;
  final String grade;
  final String marks;
  final String unstructuredLearning;
  final List<String> skills;
  final List<String> subjectsLearned;
  final List<String> interests;
  final List<String> aspirations;
  final bool isPendingSync;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.age,
    this.gender = '',
    required this.state,
    required this.district,
    this.preferredLanguage = 'en',
    required this.incomeBracket,
    required this.casteCategory,
    this.isFirstGenLearner = false,
    this.hasFormalCurriculum = true,
    required this.curriculum,
    this.board = '',
    this.grade = '',
    this.marks = '',
    this.unstructuredLearning = '',
    required this.skills,
    required this.subjectsLearned,
    required this.interests,
    required this.aspirations,
    this.isPendingSync = false,
  });

  StudentProfile copyWith({
    String? id,
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
    String? curriculum,
    String? board,
    String? grade,
    String? marks,
    String? unstructuredLearning,
    List<String>? skills,
    List<String>? subjectsLearned,
    List<String>? interests,
    List<String>? aspirations,
    bool? isPendingSync,
  }) {
    return StudentProfile(
      id: id ?? this.id,
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
      curriculum: curriculum ?? this.curriculum,
      board: board ?? this.board,
      grade: grade ?? this.grade,
      marks: marks ?? this.marks,
      unstructuredLearning: unstructuredLearning ?? this.unstructuredLearning,
      skills: skills ?? this.skills,
      subjectsLearned: subjectsLearned ?? this.subjectsLearned,
      interests: interests ?? this.interests,
      aspirations: aspirations ?? this.aspirations,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'curriculum': curriculum,
      'board': board,
      'grade': grade,
      'marks': marks,
      'unstructuredLearning': unstructuredLearning,
      'skills': skills,
      'subjectsLearned': subjectsLearned,
      'interests': interests,
      'aspirations': aspirations,
      'isPendingSync': isPendingSync,
    };
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String? ?? '',
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
      curriculum: json['curriculum'] as String? ?? '',
      board: json['board'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
      marks: json['marks'] as String? ?? '',
      unstructuredLearning: json['unstructuredLearning'] as String? ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      subjectsLearned: json['subjectsLearned'] != null
          ? List<String>.from(json['subjectsLearned'])
          : [],
      interests:
          json['interests'] != null ? List<String>.from(json['interests']) : [],
      aspirations: json['aspirations'] != null
          ? List<String>.from(json['aspirations'])
          : [],
      isPendingSync: json['isPendingSync'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    // Redact sensitive fields per security rule
    return 'StudentProfile(id: $id, name: $name, age: $age, state: $state, district: $district, caste: [REDACTED], income: [REDACTED], firstGen: $isFirstGenLearner, formal: $hasFormalCurriculum, curriculum: $curriculum, pendingSync: $isPendingSync)';
  }
}
