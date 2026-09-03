import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/network/network_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/domain/models/student_profile.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/datasources/academic_options_datasource.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/models/onboarding_draft.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Provider for regional options datasource
final academicOptionsProvider = Provider<AcademicOptionsDatasource>((ref) {
  return const AcademicOptionsDatasource();
});

/// Provider for active OnboardingRepository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final profileRepo = ref.watch(profileRepositoryProvider);
  return OnboardingRepositoryImpl(
    database: database,
    profileRepository: profileRepo,
  );
});

/// Immutable UI state for onboarding wizard.
class OnboardingState {
  final OnboardingDraft draft;
  final bool isLoading;
  final bool isSavingDraft;
  final bool isSubmitting;
  final bool isSyncing;
  final bool hasSubmitted;
  final StudentProfile? submittedProfile;
  final int pendingSyncCount;
  final String? errorMessage;

  const OnboardingState({
    required this.draft,
    this.isLoading = false,
    this.isSavingDraft = false,
    this.isSubmitting = false,
    this.isSyncing = false,
    this.hasSubmitted = false,
    this.submittedProfile,
    this.pendingSyncCount = 0,
    this.errorMessage,
  });

  int get currentStep => draft.currentStep;

  OnboardingState copyWith({
    OnboardingDraft? draft,
    bool? isLoading,
    bool? isSavingDraft,
    bool? isSubmitting,
    bool? isSyncing,
    bool? hasSubmitted,
    StudentProfile? submittedProfile,
    int? pendingSyncCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSyncing: isSyncing ?? this.isSyncing,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      submittedProfile: submittedProfile ?? this.submittedProfile,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// State notifier managing the multi-step onboarding wizard.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;
  final Ref _ref;

  OnboardingNotifier(
    this._repository,
    this._ref, {
    required String userId,
    String? displayName,
    String? preferredLanguage,
  }) : super(
          OnboardingState(
            draft: OnboardingDraft(
              userId: userId,
              name: displayName ?? '',
              preferredLanguage: preferredLanguage ?? 'en',
              currentStep: 0,
            ),
            isLoading: false,
          ),
        );

  /// Initializes the wizard by restoring any saved progress from Drift SQLite.
  /// If no draft exists, pre-fills with the authenticated student's name.
  Future<void> init({
    required String userId,
    String? displayName,
    String? preferredLanguage,
  }) async {
    try {
      final savedDraft = await _repository.loadDraft(userId);
      final pendingCount = await _repository.getPendingSyncCount();

      if (savedDraft != null) {
        state = state.copyWith(
          draft: savedDraft,
          isLoading: false,
          pendingSyncCount: pendingCount,
        );
      } else {
        final initialDraft = OnboardingDraft(
          userId: userId,
          name: displayName ?? '',
          preferredLanguage: preferredLanguage ?? 'en',
          currentStep: 0,
        );
        state = state.copyWith(
          draft: initialDraft,
          isLoading: false,
          pendingSyncCount: pendingCount,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }



  /// Changes the active stepper step and saves immediately to Drift local storage.
  Future<void> setStep(int step) async {
    if (step < 0 || step > 5) return;
    final updated = state.draft.copyWith(
      currentStep: step,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated, isSavingDraft: true);
    await _repository.saveDraft(updated);
    state = state.copyWith(isSavingDraft: false);
  }

  /// Updates Step 1: Basic Info
  Future<void> updateBasicInfo({
    required String name,
    required int age,
    required String gender,
    required String stateName,
    required String district,
    required String preferredLanguage,
  }) async {
    final updated = state.draft.copyWith(
      name: name,
      age: age,
      gender: gender,
      state: stateName,
      district: district,
      preferredLanguage: preferredLanguage,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated);
    await _repository.saveDraft(updated);
  }

  /// Updates Step 2: Family & Economic Context
  Future<void> updateEconomicContext({
    required String incomeBracket,
    required String casteCategory,
    required bool isFirstGenLearner,
  }) async {
    final updated = state.draft.copyWith(
      incomeBracket: incomeBracket,
      casteCategory: casteCategory,
      isFirstGenLearner: isFirstGenLearner,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated);
    await _repository.saveDraft(updated);
  }

  /// Updates Step 3: Academic Background (Structured + Unstructured)
  Future<void> updateAcademicBackground({
    required bool hasFormalCurriculum,
    required String board,
    required String grade,
    required String marks,
    required String unstructuredLearning,
    required List<String> practicalSubjects,
  }) async {
    final updated = state.draft.copyWith(
      hasFormalCurriculum: hasFormalCurriculum,
      board: board,
      grade: grade,
      marks: marks,
      unstructuredLearning: unstructuredLearning,
      practicalSubjects: practicalSubjects,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated);
    await _repository.saveDraft(updated);
  }

  /// Updates Step 4: Skills & Interests
  Future<void> updateSkillsAndInterests({
    required List<String> skills,
    required List<String> interests,
    required List<String> customSkills,
    required String freeTextInterests,
  }) async {
    final updated = state.draft.copyWith(
      skills: skills,
      interests: interests,
      customSkills: customSkills,
      freeTextInterests: freeTextInterests,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated);
    await _repository.saveDraft(updated);
  }

  /// Updates Step 5: Aspirations
  Future<void> updateAspirations({
    required String aspirationText,
    required List<String> selectedAspirationPrompts,
  }) async {
    final updated = state.draft.copyWith(
      aspirationText: aspirationText,
      selectedAspirationPrompts: selectedAspirationPrompts,
      lastSavedAt: DateTime.now(),
    );
    state = state.copyWith(draft: updated);
    await _repository.saveDraft(updated);
  }

  /// Submits the completed profile.
  /// If online, writes to backend and local DB.
  /// If offline, marks as pending sync in local DB and queue.
  Future<StudentProfile?> submitProfile({bool? forceOffline}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final simState = _ref.read(networkSimulatorProvider);
    final isOffline = forceOffline ?? simState.simulateFailure;

    try {
      final profile = state.draft.toStudentProfile();
      final result = await _repository.submitProfile(profile, isOnline: !isOffline);

      // Update student session in auth storage so student has completed profile
      final tokenStorage = _ref.read(authTokenStorageProvider);
      final cachedUser = await tokenStorage.getCachedUser();
      if (cachedUser != null) {
        await tokenStorage.saveUser(cachedUser.copyWith(isProfileComplete: true));
      } else {
        final currentAuthUser = _ref.read(authStateProvider).user;
        if (currentAuthUser != null) {
          await tokenStorage.saveUser(currentAuthUser.copyWith(isProfileComplete: true));
        }
      }

      final pendingCount = await _repository.getPendingSyncCount();

      state = state.copyWith(
        isSubmitting: false,
        hasSubmitted: true,
        submittedProfile: result,
        pendingSyncCount: pendingCount,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Flushes any pending offline profiles to backend when network returns
  Future<int> syncPending() async {
    state = state.copyWith(isSyncing: true);
    try {
      final syncedCount = await _repository.syncPendingProfiles();
      final pendingCount = await _repository.getPendingSyncCount();
      state = state.copyWith(
        isSyncing: false,
        pendingSyncCount: pendingCount,
      );
      return syncedCount;
    } catch (e) {
      state = state.copyWith(isSyncing: false, errorMessage: e.toString());
      return 0;
    }
  }
}

/// Provider for stable current student user ID across app restarts
final currentUserIdProvider = Provider<String>((ref) {
  final authUser = ref.watch(authStateProvider).user;
  if (authUser != null && authUser.id.isNotEmpty) {
    return authUser.id;
  }
  return 'dc_current_student';
});

/// Main onboarding state provider
final onboardingStateProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  final authUser = ref.watch(authStateProvider).user;

  final notifier = OnboardingNotifier(
    repo,
    ref,
    userId: userId,
    displayName: authUser?.displayName,
  );

  notifier.init(
    userId: userId,
    displayName: authUser?.displayName,
  );

  return notifier;
});


