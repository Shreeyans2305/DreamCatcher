import 'reference.dart';

class StudentEducation {
  final String id;
  final String? institutionName;
  final String educationLevel;
  final String? curriculum;
  final String? board;
  final String? fieldOfStudy;
  final String? description;
  final String status;

  StudentEducation({
    required this.id,
    this.institutionName,
    required this.educationLevel,
    this.curriculum,
    this.board,
    this.fieldOfStudy,
    this.description,
    this.status = 'completed',
  });

  factory StudentEducation.fromJson(Map<String, dynamic> json) {
    return StudentEducation(
      id: json['id'] as String,
      institutionName: json['institution_name'] as String?,
      educationLevel: json['education_level'] as String? ?? 'secondary',
      curriculum: json['curriculum'] as String?,
      board: json['board'] as String?,
      fieldOfStudy: json['field_of_study'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'completed',
    );
  }
}

class StudentSkill {
  final String id;
  final String skillId;
  final String? proficiency;
  final double? yearsExperience;
  final SkillItem? skill;

  StudentSkill({
    required this.id,
    required this.skillId,
    this.proficiency,
    this.yearsExperience,
    this.skill,
  });

  factory StudentSkill.fromJson(Map<String, dynamic> json) {
    return StudentSkill(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      proficiency: json['proficiency'] as String?,
      yearsExperience: (json['years_experience'] as num?)?.toDouble(),
      skill: json['skill'] != null ? SkillItem.fromJson(json['skill']) : null,
    );
  }
}

class StudentInterest {
  final String id;
  final String interestId;
  final double strength;
  final InterestItem? interest;

  StudentInterest({
    required this.id,
    required this.interestId,
    this.strength = 0.5,
    this.interest,
  });

  factory StudentInterest.fromJson(Map<String, dynamic> json) {
    return StudentInterest(
      id: json['id'] as String,
      interestId: json['interest_id'] as String,
      strength: (json['strength'] as num?)?.toDouble() ?? 0.5,
      interest: json['interest'] != null ? InterestItem.fromJson(json['interest']) : null,
    );
  }
}

class StudentAspiration {
  final String id;
  final String aspirationText;
  final int priority;

  StudentAspiration({
    required this.id,
    required this.aspirationText,
    this.priority = 1,
  });

  factory StudentAspiration.fromJson(Map<String, dynamic> json) {
    return StudentAspiration(
      id: json['id'] as String,
      aspirationText: json['aspiration_text'] as String,
      priority: json['priority'] as int? ?? 1,
    );
  }
}

class StudentProfile {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? locationId;
  final String preferredLanguage;
  final double profileCompleteness; // 0.0 to 1.0
  final LocationItem? location;
  final List<StudentEducation> educationRecords;
  final List<StudentSkill> skills;
  final List<StudentInterest> interests;
  final List<StudentAspiration> aspirations;

  StudentProfile({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.locationId,
    this.preferredLanguage = 'en',
    this.profileCompleteness = 0.0,
    this.location,
    this.educationRecords = const [],
    this.skills = const [],
    this.interests = const [],
    this.aspirations = const [],
  });

  int get completenessPercentage => (profileCompleteness * 100).round();

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      locationId: json['location_id'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      profileCompleteness: (json['profile_completeness'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] != null ? LocationItem.fromJson(json['location']) : null,
      educationRecords: (json['education_records'] as List<dynamic>?)
              ?.map((e) => StudentEducation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => StudentSkill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => StudentInterest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aspirations: (json['aspirations'] as List<dynamic>?)
              ?.map((e) => StudentAspiration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
