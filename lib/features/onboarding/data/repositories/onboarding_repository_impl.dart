import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../profile/domain/models/student_profile.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../../domain/models/onboarding_draft.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Implementation of [OnboardingRepository] backed by Drift SQLite local database
/// and coordinating with [ProfileRepository] for remote synchronization.
class OnboardingRepositoryImpl implements OnboardingRepository {
  final AppDatabase database;
  final ProfileRepository profileRepository;

  const OnboardingRepositoryImpl({
    required this.database,
    required this.profileRepository,
  });

  @override
  Future<OnboardingDraft?> loadDraft(String userId) async {
    try {
      final row = await database.getOnboardingDraft(userId);
      if (row == null) return null;
      return OnboardingDraft.fromJsonString(row.draftJson);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveDraft(OnboardingDraft draft) async {
    await database.upsertOnboardingDraft(
      OnboardingDraftsCompanion(
        userId: Value(draft.userId),
        currentStep: Value(draft.currentStep),
        draftJson: Value(draft.toJsonString()),
        isPendingSync: Value(draft.isPendingSync),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> clearDraft(String userId) async {
    await database.deleteOnboardingDraft(userId);
  }

  @override
  Future<StudentProfile> submitProfile(
    StudentProfile profile, {
    required bool isOnline,
  }) async {
    if (isOnline) {
      // 1. Submit to remote/mock backend
      await profileRepository.updateProfile(profile);

      // 2. Persist locally with isPendingSync = false
      await _persistProfileLocal(profile, isPending: false);

      // 3. Clear the onboarding draft now that it's synced
      await clearDraft(profile.id);

      return profile.copyWith(isPendingSync: false);
    } else {
      // Offline mode: queue locally with isPendingSync = true
      final queuedProfile = profile.copyWith(isPendingSync: true);

      // Save to Drift Profiles table so student can immediately see and use their profile offline
      await _persistProfileLocal(queuedProfile, isPending: true);

      // Also persist in OnboardingDrafts with pending flag for redundancy
      await database.upsertOnboardingDraft(
        OnboardingDraftsCompanion(
          userId: Value(profile.id),
          currentStep: const Value(5), // Review step
          draftJson: Value(jsonEncode(queuedProfile.toJson())),
          isPendingSync: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );

      return queuedProfile;
    }
  }

  @override
  Future<int> syncPendingProfiles() async {
    int count = 0;

    // Check pending drafts in OnboardingDrafts table
    final pendingDrafts = await database.getPendingSyncDrafts();
    for (final draftRow in pendingDrafts) {
      try {
        final profileMap = jsonDecode(draftRow.draftJson) as Map<String, dynamic>;
        final profile = StudentProfile.fromJson(profileMap);

        // Push to server
        await profileRepository.updateProfile(profile);

        // Update local profile row as synced
        await _persistProfileLocal(profile, isPending: false);

        // Remove from pending drafts
        await clearDraft(draftRow.userId);
        count++;
      } catch (_) {
        // Leave in queue for subsequent retry on network recovery
      }
    }

    // Also check pending profiles in Profiles table
    final pendingProfiles = await database.getPendingSyncProfiles();
    for (final p in pendingProfiles) {
      try {
        final profile = StudentProfile(
          id: p.id,
          name: p.name,
          age: p.age ?? 17,
          gender: p.gender ?? '',
          state: p.state ?? '',
          district: p.district ?? '',
          preferredLanguage: p.preferredLanguage ?? 'en',
          incomeBracket: p.incomeBracket ?? '',
          casteCategory: p.casteCategory ?? '',
          isFirstGenLearner: p.isFirstGenLearner ?? false,
          hasFormalCurriculum: p.hasFormalCurriculum ?? true,
          curriculum: p.curriculum ?? '',
          board: p.board ?? '',
          grade: p.grade ?? '',
          marks: p.marks ?? '',
          unstructuredLearning: p.unstructuredLearning ?? '',
          skills: p.skills != null ? List<String>.from(jsonDecode(p.skills!)) : [],
          subjectsLearned:
              p.subjects != null ? List<String>.from(jsonDecode(p.subjects!)) : [],
          interests:
              p.interests != null ? List<String>.from(jsonDecode(p.interests!)) : [],
          aspirations:
              p.aspirations != null ? List<String>.from(jsonDecode(p.aspirations!)) : [],
          isPendingSync: false,
        );

        await profileRepository.updateProfile(profile);
        await _persistProfileLocal(profile, isPending: false);
        count++;
      } catch (_) {
        // Retry next time
      }
    }

    return count;
  }

  @override
  Future<int> getPendingSyncCount() async {
    final drafts = await database.getPendingSyncDrafts();
    return drafts.length;
  }

  Future<void> _persistProfileLocal(StudentProfile profile, {required bool isPending}) async {
    await database.upsertProfile(
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
        isPendingSync: Value(isPending),
      ),
    );
  }
}
