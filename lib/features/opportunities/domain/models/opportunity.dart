enum OpportunityCategory {
  careerPathway,
  scholarship,
  entranceExam,
  course,
  internship,
  higherEd;

  String toDbString() {
    switch (this) {
      case OpportunityCategory.careerPathway:
        return 'career_pathway';
      case OpportunityCategory.scholarship:
        return 'scholarship';
      case OpportunityCategory.entranceExam:
        return 'entrance_exam';
      case OpportunityCategory.course:
        return 'course';
      case OpportunityCategory.internship:
        return 'internship';
      case OpportunityCategory.higherEd:
        return 'higher_ed';
    }
  }

  static OpportunityCategory fromDbString(String str) {
    switch (str) {
      case 'career_pathway':
        return OpportunityCategory.careerPathway;
      case 'scholarship':
        return OpportunityCategory.scholarship;
      case 'entrance_exam':
        return OpportunityCategory.entranceExam;
      case 'course':
        return OpportunityCategory.course;
      case 'internship':
        return OpportunityCategory.internship;
      case 'higher_ed':
        return OpportunityCategory.higherEd;
      default:
        return OpportunityCategory.scholarship;
    }
  }
}

/// Represents an educational or career opportunity for students.
class Opportunity {
  final String id;
  final String title;
  final OpportunityCategory category;
  final String provider;
  final String description;
  final String eligibility;
  final String? deadline;
  final String? url;

  const Opportunity({
    required this.id,
    required this.title,
    required this.category,
    required this.provider,
    required this.description,
    required this.eligibility,
    this.deadline,
    this.url,
  });

  @override
  String toString() =>
      'Opportunity(id: $id, title: $title, category: ${category.name}, provider: $provider)';
}
