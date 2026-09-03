import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/repositories/mock_profile_repository.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Active profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final useMock = ref.watch(useMockRepositoriesProvider);
  final database = ref.watch(appDatabaseProvider);
  if (useMock) {
    return MockProfileRepository(database: database);
  }
  // HttpProfileRepository will be returned here when backend is ready
  return MockProfileRepository(database: database);
});

/// Async notifier for managing the student profile state
class ProfileNotifier extends StateNotifier<AsyncValue<StudentProfile>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile([String id = 'std_rural_001']) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile(id);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(StudentProfile profile) async {
    try {
      await _repository.updateProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final studentProfileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<StudentProfile>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repo);
});
