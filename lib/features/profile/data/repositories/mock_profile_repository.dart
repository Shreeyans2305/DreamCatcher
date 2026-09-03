import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Mock ProfileRepository returning realistic rural Indian student data
/// with 300-1500ms latency, backed by offline Drift persistence.
class MockProfileRepository implements ProfileRepository {
  final AppDatabase? database;
  final Random _random = Random();

  StudentProfile _profile = const StudentProfile(
    id: 'std_rural_001',
    name: 'Priya Sharma',
    age: 17,
    state: 'Madhya Pradesh',
    district: 'Hoshangabad',
    incomeBracket: '< ₹1,50,000 / year',
    casteCategory: 'OBC',
    curriculum: 'MP Board of Secondary Education (Class 12 - PCM)',
    skills: [
      'Basic Computer Operation',
      'Digital Payments & UPI',
      'Solar Panel Maintenance Basics',
      'Mathematics Problem Solving',
    ],
    subjectsLearned: ['Physics', 'Chemistry', 'Mathematics', 'Hindi Literature', 'English'],
    interests: [
      'Solar Energy Systems',
      'Rural Agritech Solutions',
      'Polytechnic Engineering',
      'Community Teaching',
    ],
    aspirations: [
      'Pursue a Polytechnic Diploma in Renewable Energy',
      'Secure a Government Post-Matric Scholarship for Higher Education',
    ],
  );

  MockProfileRepository({this.database});

  Future<void> _simulateDelay() async {
    final int delayMs = 300 + _random.nextInt(1201);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Future<StudentProfile> getProfile(String studentId) async {
    await _simulateDelay();

    // If Drift DB is available, check offline cache first or write cache
    if (database != null) {
      final cached = await database!.getProfile(studentId);
      if (cached != null) {
        return StudentProfile(
          id: cached.id,
          name: cached.name,
          age: cached.age ?? 17,
          gender: cached.gender ?? '',
          state: cached.state ?? '',
          district: cached.district ?? '',
          preferredLanguage: cached.preferredLanguage ?? 'en',
          incomeBracket: cached.incomeBracket ?? '< ₹1,50,000 / year',
          casteCategory: cached.casteCategory ?? 'General',
          isFirstGenLearner: cached.isFirstGenLearner ?? false,
          hasFormalCurriculum: cached.hasFormalCurriculum ?? true,
          curriculum: cached.curriculum ?? '',
          board: cached.board ?? '',
          grade: cached.grade ?? '',
          marks: cached.marks ?? '',
          unstructuredLearning: cached.unstructuredLearning ?? '',
          skills: cached.skills != null ? List<String>.from(jsonDecode(cached.skills!)) : [],
          subjectsLearned:
              cached.subjects != null ? List<String>.from(jsonDecode(cached.subjects!)) : [],
          interests:
              cached.interests != null ? List<String>.from(jsonDecode(cached.interests!)) : [],
          aspirations:
              cached.aspirations != null ? List<String>.from(jsonDecode(cached.aspirations!)) : [],
          isPendingSync: cached.isPendingSync,
        );
      } else {
        // Cache initial mock data offline in Drift
        await database!.upsertProfile(
          ProfilesCompanion(
            id: Value(_profile.id),
            name: Value(_profile.name),
            age: Value(_profile.age),
            state: Value(_profile.state),
            district: Value(_profile.district),
            incomeBracket: Value(_profile.incomeBracket),
            casteCategory: Value(_profile.casteCategory),
            curriculum: Value(_profile.curriculum),
            skills: Value(jsonEncode(_profile.skills)),
            subjects: Value(jsonEncode(_profile.subjectsLearned)),
            interests: Value(jsonEncode(_profile.interests)),
            aspirations: Value(jsonEncode(_profile.aspirations)),
            gender: Value(_profile.gender),
            preferredLanguage: Value(_profile.preferredLanguage),
            isFirstGenLearner: Value(_profile.isFirstGenLearner),
            hasFormalCurriculum: Value(_profile.hasFormalCurriculum),
            board: Value(_profile.board),
            grade: Value(_profile.grade),
            marks: Value(_profile.marks),
            unstructuredLearning: Value(_profile.unstructuredLearning),
            isPendingSync: Value(_profile.isPendingSync),
          ),
        );
      }
    }

    return _profile;
  }

  @override
  Future<void> updateProfile(StudentProfile profile) async {
    await _simulateDelay();
    _profile = profile;

    if (database != null) {
      await database!.upsertProfile(
        ProfilesCompanion(
          id: Value(profile.id),
          name: Value(profile.name),
          age: Value(profile.age),
          state: Value(profile.state),
          district: Value(profile.district),
          incomeBracket: Value(profile.incomeBracket),
          casteCategory: Value(profile.casteCategory),
          curriculum: Value(profile.curriculum),
          skills: Value(jsonEncode(profile.skills)),
          subjects: Value(jsonEncode(profile.subjectsLearned)),
          interests: Value(jsonEncode(profile.interests)),
          aspirations: Value(jsonEncode(profile.aspirations)),
          gender: Value(profile.gender),
          preferredLanguage: Value(profile.preferredLanguage),
          isFirstGenLearner: Value(profile.isFirstGenLearner),
          hasFormalCurriculum: Value(profile.hasFormalCurriculum),
          board: Value(profile.board),
          grade: Value(profile.grade),
          marks: Value(profile.marks),
          unstructuredLearning: Value(profile.unstructuredLearning),
          isPendingSync: Value(profile.isPendingSync),
        ),
      );
    }
  }
}

