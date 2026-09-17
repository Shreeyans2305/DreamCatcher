import '../../core/localization/opportunity_translator.dart';
import '../../l10n/app_localizations.dart';
import 'eligibility.dart';
import 'reference.dart';

class ScholarshipDetails {
  final double? amount;
  final String? recurrence;
  final String? description;

  ScholarshipDetails({this.amount, this.recurrence, this.description});

  factory ScholarshipDetails.fromJson(Map<String, dynamic> json) {
    return ScholarshipDetails(
      amount: (json['amount'] as num?)?.toDouble(),
      recurrence: json['recurrence'] as String?,
      description: json['description'] as String?,
    );
  }
}

class CourseDetails {
  final String? educationLevel;
  final String? field;
  final String? duration;
  final String? mode;

  CourseDetails({this.educationLevel, this.field, this.duration, this.mode});

  factory CourseDetails.fromJson(Map<String, dynamic> json) {
    return CourseDetails(
      educationLevel: json['education_level'] as String?,
      field: json['field'] as String?,
      duration: json['duration'] as String?,
      mode: json['mode'] as String?,
    );
  }
}

class EntranceExamDetails {
  final String? conductingBody;
  final String? examMode;
  final String? registrationDeadline;
  final String? examinationDate;
  final double? applicationFee;

  EntranceExamDetails({
    this.conductingBody,
    this.examMode,
    this.registrationDeadline,
    this.examinationDate,
    this.applicationFee,
  });

  factory EntranceExamDetails.fromJson(Map<String, dynamic> json) {
    return EntranceExamDetails(
      conductingBody: json['conducting_body'] as String?,
      examMode: json['exam_mode'] as String?,
      registrationDeadline: json['registration_deadline'] as String?,
      examinationDate: json['examination_date'] as String?,
      applicationFee: (json['application_fee'] as num?)?.toDouble(),
    );
  }
}

class InternshipDetails {
  final bool remote;
  final String? duration;
  final double? stipend;
  final String? applicationDeadline;
  final String? workDescription;

  InternshipDetails({
    this.remote = false,
    this.duration,
    this.stipend,
    this.applicationDeadline,
    this.workDescription,
  });

  factory InternshipDetails.fromJson(Map<String, dynamic> json) {
    return InternshipDetails(
      remote: json['remote'] as bool? ?? false,
      duration: json['duration'] as String?,
      stipend: (json['stipend'] as num?)?.toDouble(),
      applicationDeadline: json['application_deadline'] as String?,
      workDescription: json['work_description'] as String?,
    );
  }
}

class Opportunity {
  final String id;
  final String type; // scholarship, course, entrance_exam, internship
  final String title;
  final String? description;
  final String status;
  final String? officialUrl;
  final String? applicationUrl;
  final String? applicationStart;
  final String? applicationDeadline;
  final LocationItem? location;
  final ScholarshipDetails? scholarship;
  final CourseDetails? course;
  final EntranceExamDetails? entranceExam;
  final InternshipDetails? internship;
  
  // Client-side attached eligibility evaluation (if checked for current student)
  EligibilityCheckResult? eligibilityResult;

  Opportunity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.status = 'active',
    this.officialUrl,
    this.applicationUrl,
    this.applicationStart,
    this.applicationDeadline,
    this.location,
    this.scholarship,
    this.course,
    this.entranceExam,
    this.internship,
    this.eligibilityResult,
  });

  String get typeLabel {
    switch (type.toLowerCase()) {
      case 'scholarship':
        return 'Scholarship';
      case 'course':
        return 'Vocational Course';
      case 'entrance_exam':
        return 'Entrance Exam';
      case 'internship':
        return 'Internship / Fellowship';
      default:
        return 'Opportunity';
    }
  }

  String getLocalizedTypeLabel(AppLocalizations l10n) {
    return OpportunityTranslator.getTypeLabel(type, l10n);
  }

  String getLocalizedTitle(String langCode) {
    return OpportunityTranslator.getTitle(title, langCode);
  }

  String? getLocalizedDescription(String langCode) {
    return OpportunityTranslator.getDescription(description, title, langCode);
  }

  String? get highlightBenefit {
    if (scholarship?.amount != null) {
      return '₹${scholarship!.amount!.toStringAsFixed(0)} ${scholarship?.recurrence ?? "award"}';
    }
    if (internship?.stipend != null && internship!.stipend! > 0) {
      return '₹${internship!.stipend!.toStringAsFixed(0)}/mo stipend';
    }
    if (course?.duration != null) {
      return course!.duration;
    }
    if (entranceExam?.conductingBody != null) {
      return entranceExam!.conductingBody;
    }
    return null;
  }

  String? getLocalizedHighlightBenefit(AppLocalizations l10n, String langCode) {
    return OpportunityTranslator.getHighlightBenefit(
      type: type,
      amount: scholarship?.amount,
      recurrence: scholarship?.recurrence,
      stipend: internship?.stipend,
      duration: course?.duration,
      conductingBody: entranceExam?.conductingBody,
      l10n: l10n,
      langCode: langCode,
    );
  }

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'scholarship',
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      officialUrl: json['official_url'] as String?,
      applicationUrl: json['application_url'] as String?,
      applicationStart: json['application_start'] as String?,
      applicationDeadline: json['application_deadline'] as String?,
      location: json['location'] != null ? LocationItem.fromJson(json['location']) : null,
      scholarship: json['scholarship'] != null ? ScholarshipDetails.fromJson(json['scholarship']) : null,
      course: json['course'] != null ? CourseDetails.fromJson(json['course']) : null,
      entranceExam: json['entrance_exam'] != null ? EntranceExamDetails.fromJson(json['entrance_exam']) : null,
      internship: json['internship'] != null ? InternshipDetails.fromJson(json['internship']) : null,
    );
  }
}
