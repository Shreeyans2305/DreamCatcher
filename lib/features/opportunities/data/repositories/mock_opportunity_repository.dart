import 'dart:math';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' hide Opportunity;
import '../../domain/models/opportunity.dart';
import '../../domain/repositories/opportunity_repository.dart';

/// Mock OpportunityRepository with realistic Indian rural education & career data.
/// Supports offline caching via Drift SQLite.
class MockOpportunityRepository implements OpportunityRepository {
  final AppDatabase? database;
  final Random _random = Random();

  static final List<Opportunity> _mockData = [
    // Career Pathways
    const Opportunity(
      id: 'opp_path_01',
      title: 'Solar PV & Rural Microgrid Technician Pathway',
      category: OpportunityCategory.careerPathway,
      provider: 'Ministry of New & Renewable Energy (MNRE)',
      description:
          'Structured pathway from Class 10/12 to certified Surya Mitra solar technician, leading to jobs in rural solar pump installation and solar farm maintenance.',
      eligibility: 'Class 10th or 12th pass with Science/Maths background',
      deadline: 'Rolling Admission',
      url: 'https://mnre.gov.in',
    ),
    const Opportunity(
      id: 'opp_path_02',
      title: 'Gram Panchayat Digital Services Coordinator',
      category: OpportunityCategory.careerPathway,
      provider: 'Common Services Centers (CSC) / Digital India',
      description:
          'Operate village digital kendras offering e-governance, banking, and certificate services to rural citizens.',
      eligibility: 'Class 12th pass with basic computer literacy',
      deadline: 'Ongoing recruitment',
      url: 'https://csc.gov.in',
    ),

    // Scholarships
    const Opportunity(
      id: 'opp_sch_01',
      title: 'Post-Matric Scholarship Scheme for SC/ST/OBC Students',
      category: OpportunityCategory.scholarship,
      provider: 'Ministry of Social Justice and Empowerment / State Govt',
      description:
          'Complete financial assistance including maintenance allowance, book grant, and tuition fee waiver for higher secondary, diploma, and degree courses.',
      eligibility: 'SC/ST/OBC students with family annual income under ₹2,50,000',
      deadline: '31 October 2026',
      url: 'https://scholarships.gov.in',
    ),
    const Opportunity(
      id: 'opp_sch_02',
      title: 'Pragati Scholarship Scheme for Girl Students in Technical Education',
      category: OpportunityCategory.scholarship,
      provider: 'All India Council for Technical Education (AICTE)',
      description:
          '₹50,000 per annum towards college fee, books, computer equipment, and software for female students entering diploma or degree engineering.',
      eligibility: 'Girl students admitted to AICTE approved diploma/degree; Family income < ₹8,00,000',
      deadline: '30 November 2026',
      url: 'https://aicte-india.org',
    ),

    // Entrance Exams
    const Opportunity(
      id: 'opp_exam_01',
      title: 'State Polytechnic Joint Entrance Examination (Polytechnic Diploma)',
      category: OpportunityCategory.entranceExam,
      provider: 'Board of Technical Education (State Govt)',
      description:
          'Statewide entrance examination for 3-year government polytechnic diploma courses in Mechanical, Electrical, Civil, and Computer Engineering.',
      eligibility: 'Class 10th or 12th passed with minimum 35% marks',
      deadline: '15 April 2026',
      url: 'https://jeecup.admissions.nic.in',
    ),
    const Opportunity(
      id: 'opp_exam_02',
      title: 'ICAR AIEEA (UG) - All India Entrance Examination for Agriculture',
      category: OpportunityCategory.entranceExam,
      provider: 'National Testing Agency (NTA) & ICAR',
      description:
          'National entrance exam for admission into 4-year B.Sc. Agriculture, Horticulture, Forestry, and Agricultural Engineering in State Agricultural Universities.',
      eligibility: 'Class 12th with Physics, Chemistry, Biology/Maths/Agriculture',
      deadline: '10 May 2026',
      url: 'https://icar.nta.nic.in',
    ),

    // Courses
    const Opportunity(
      id: 'opp_course_01',
      title: 'Surya Mitra Skill Development Program (Solar Technician)',
      category: OpportunityCategory.course,
      provider: 'National Institute of Solar Energy (NISE)',
      description:
          '600 hours of practical, hands-on solar training covering installation, operation, and troubleshooting of rooftop and agricultural solar pump systems. 100% free with boarding.',
      eligibility: '10th pass + ITI (Electrical/Wireman) or 12th pass with PCM; Age 18-35',
      deadline: 'Batch starting quarterly',
      url: 'https://nise.res.in',
    ),
    const Opportunity(
      id: 'opp_course_02',
      title: 'RSETI Certificate in Micro-Enterprise Accounting & GST',
      category: OpportunityCategory.course,
      provider: 'Rural Self Employment Training Institute (Ministry of Rural Development)',
      description:
          'Free 30-day residential course teaching practical accounting, Tally, and GST filing for rural businesses, with post-training bank loan facilitation.',
      eligibility: 'Class 10th or 12th pass; Rural resident aged 18-45',
      deadline: 'Monthly enrollments at District RSETI',
      url: 'https://nirdpr.org.in',
    ),

    // Internships
    const Opportunity(
      id: 'opp_intern_01',
      title: 'Krishi Vigyan Kendra (KVK) Agri-Extension Trainee',
      category: OpportunityCategory.internship,
      provider: 'Indian Council of Agricultural Research (ICAR)',
      description:
          '3-month stipend-supported practical internship assisting agricultural scientists in soil health testing, crop trials, and farmer training camps.',
      eligibility: 'Students or diploma holders in Agriculture, Rural Development, or Sciences',
      deadline: '15 June 2026',
      url: 'https://kvk.icar.gov.in',
    ),

    // Higher Ed
    const Opportunity(
      id: 'opp_he_01',
      title: 'Diploma in Renewable Energy & Electrical Systems',
      category: OpportunityCategory.higherEd,
      provider: 'Government Polytechnic College',
      description:
          '3-year state accredited diploma offering direct entry into junior engineer roles in state electricity boards, discoms, and private solar developers.',
      eligibility: 'Class 10th pass through Polytechnic Entrance',
      deadline: 'Admissions open via state counseling',
      url: 'https://dte.gov.in',
    ),
  ];

  MockOpportunityRepository({this.database});

  Future<void> _simulateDelay() async {
    final int delayMs = 300 + _random.nextInt(1201);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Future<List<Opportunity>> getOpportunities({OpportunityCategory? category}) async {
    await _simulateDelay();

    // Cache to Drift SQLite if database is initialized
    if (database != null) {
      try {
        final companions = _mockData
            .map(
              (o) => OpportunitiesCompanion(
                id: Value(o.id),
                title: Value(o.title),
                category: Value(o.category.toDbString()),
                provider: Value(o.provider),
                description: Value(o.description),
                eligibility: Value(o.eligibility),
                deadline: Value(o.deadline),
                url: Value(o.url),
              ),
            )
            .toList();
        await database!.replaceOpportunities(companions);
      } catch (_) {
        // Fallback gracefully if database busy
      }
    }

    if (category == null) {
      return _mockData;
    }
    return _mockData.where((opp) => opp.category == category).toList();
  }

  @override
  Future<Opportunity?> getOpportunityById(String id) async {
    await _simulateDelay();
    try {
      return _mockData.firstWhere((opp) => opp.id == id);
    } catch (_) {
      return null;
    }
  }
}
