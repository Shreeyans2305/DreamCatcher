import '../../../profile/domain/models/student_profile.dart';
import '../models/onboarding_draft.dart';

/// Abstract repository managing onboarding draft persistence, wizard steps,
/// offline queueing, and synchronization.
abstract class OnboardingRepository {
  /// Loads any in-progress draft for the student from local Drift storage.
  Future<OnboardingDraft?> loadDraft(String userId);

  /// Saves progress after every step to Drift SQLite so student never loses data.
  Future<void> saveDraft(OnboardingDraft draft);

  /// Clears the draft after successful final submission and server synchronization.
  Future<void> clearDraft(String userId);

  /// Submits the final student profile.
  /// If [isOnline] is true, syncs immediately to the remote profile repository.
  /// If [isOnline] is false, saves to Drift with pending sync flag.
  Future<StudentProfile> submitProfile(StudentProfile profile, {required bool isOnline});

  /// Automatically synchronizes any offline-queued profiles when connectivity is restored.
  Future<int> syncPendingProfiles();

  /// Returns the number of profiles currently queued for synchronization.
  Future<int> getPendingSyncCount();
}
