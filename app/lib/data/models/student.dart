import 'reference.dart';

enum CompletenessStepId {
  education,
  skills,
  interests,
  aspirations,
  location,
  phone,
  avatar,
  demographics,
}

class ProfileCompletenessStep {
  final CompletenessStepId id;
  final String title;
  final String description;
  final int points;
  final bool isCompleted;

  const ProfileCompletenessStep({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.isCompleted,
  });
}

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
  final String? avatarUrl;
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
    this.avatarUrl,
    this.preferredLanguage = 'en',
    this.profileCompleteness = 0.0,
    this.location,
    this.educationRecords = const [],
    this.skills = const [],
    this.interests = const [],
    this.aspirations = const [],
  });

  StudentProfile copyWith({
    Object? avatarUrl = _unset,
    double? profileCompleteness,
  }) {
    return StudentProfile(
      id: id,
      name: name,
      phone: phone,
      email: email,
      dateOfBirth: dateOfBirth,
      gender: gender,
      locationId: locationId,
      avatarUrl: identical(avatarUrl, _unset) ? this.avatarUrl : avatarUrl as String?,
      preferredLanguage: preferredLanguage,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      location: location,
      educationRecords: educationRecords,
      skills: skills,
      interests: interests,
      aspirations: aspirations,
    );
  }

  /// Accurately computes profile completeness based on all demographic fields,
  /// avatar photo, location, and associated sub-resources.
  double get effectiveCompleteness {
    double score = 0.0;
    if (name.trim().isNotEmpty) score += 0.15;
    if (phone != null && phone!.trim().isNotEmpty) score += 0.10;
    if (email != null && email!.trim().isNotEmpty) score += 0.05;
    if (dateOfBirth != null && dateOfBirth!.trim().isNotEmpty) score += 0.05;
    if (gender != null && gender!.trim().isNotEmpty) score += 0.05;
    if (locationId != null || location != null) score += 0.10;
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) score += 0.05;

    if (educationRecords.isNotEmpty) score += 0.20;
    if (skills.isNotEmpty) score += 0.15;
    if (interests.isNotEmpty) score += 0.10;
    if (aspirations.isNotEmpty) score += 0.05;

    final calculatedScore = score.clamp(0.1, 1.0);
    final reportedScore = profileCompleteness.clamp(0.0, 1.0);
    return double.parse(
      (calculatedScore > reportedScore ? calculatedScore : reportedScore).toStringAsFixed(2),
    );
  }

  int get completenessPercentage => (effectiveCompleteness * 100).round().clamp(10, 100);

  /// Breakdown of all steps required to reach 100% profile completion
  List<ProfileCompletenessStep> get completenessSteps {
    return [
      ProfileCompletenessStep(
        id: CompletenessStepId.education,
        title: 'Education Details',
        description: 'Add qualification level, school or college',
        points: 20,
        isCompleted: educationRecords.isNotEmpty,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.skills,
        title: 'Skills & Practical Strengths',
        description: 'List technical, vocational, or creative skills',
        points: 15,
        isCompleted: skills.isNotEmpty,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.location,
        title: 'State & District Location',
        description: 'Set your state and district for state scheme quotas',
        points: 10,
        isCompleted: locationId != null || location != null,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.interests,
        title: 'Career Interests',
        description: 'Pick domains you want to explore or pursue',
        points: 10,
        isCompleted: interests.isNotEmpty,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.phone,
        title: 'Contact Phone Number',
        description: 'Add your active mobile number for scholarship alerts',
        points: 10,
        isCompleted: phone != null && phone!.trim().isNotEmpty,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.demographics,
        title: 'Date of Birth & Gender',
        description: 'Specify demographic details for age & gender reservations',
        points: 10,
        isCompleted: (dateOfBirth != null && dateOfBirth!.trim().isNotEmpty) ||
            (gender != null && gender!.trim().isNotEmpty),
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.avatar,
        title: 'Profile Picture',
        description: 'Upload a picture from your camera or gallery',
        points: 5,
        isCompleted: avatarUrl != null && avatarUrl!.trim().isNotEmpty,
      ),
      ProfileCompletenessStep(
        id: CompletenessStepId.aspirations,
        title: 'Career Aspiration',
        description: 'Add your target goal or ambition for AI matching',
        points: 5,
        isCompleted: aspirations.isNotEmpty,
      ),
    ];
  }

  List<ProfileCompletenessStep> get missingSteps =>
      completenessSteps.where((s) => !s.isCompleted).toList();

  List<ProfileCompletenessStep> get completedSteps =>
      completenessSteps.where((s) => s.isCompleted).toList();

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      locationId: json['location_id'] as String?,
      avatarUrl: json['avatar_url'] as String?,
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

const Object _unset = Object();
