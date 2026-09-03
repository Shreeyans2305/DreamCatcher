import 'package:drift/drift.dart';
import 'connection/connection.dart';
import 'tables/onboarding_draft_table.dart';
import 'tables/opportunity_table.dart';
import 'tables/profile_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, Opportunities, OnboardingDrafts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openConnection());

  @override
  int get schemaVersion => 1;

  // Profile DAO operations
  Future<Profile?> getProfile(String id) =>
      (select(profiles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> upsertProfile(ProfilesCompanion profile) =>
      into(profiles).insertOnConflictUpdate(profile);

  Future<List<Profile>> getPendingSyncProfiles() =>
      (select(profiles)..where((tbl) => tbl.isPendingSync.equals(true))).get();

  // Onboarding Draft DAO operations
  Future<OnboardingDraftData?> getOnboardingDraft(String userId) =>
      (select(onboardingDrafts)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

  Future<int> upsertOnboardingDraft(OnboardingDraftsCompanion draft) =>
      into(onboardingDrafts).insertOnConflictUpdate(draft);

  Future<int> deleteOnboardingDraft(String userId) =>
      (delete(onboardingDrafts)..where((tbl) => tbl.userId.equals(userId))).go();

  Future<List<OnboardingDraftData>> getPendingSyncDrafts() =>
      (select(onboardingDrafts)..where((tbl) => tbl.isPendingSync.equals(true))).get();


  // Opportunities DAO operations
  Future<List<Opportunity>> getAllOpportunities() => select(opportunities).get();

  Future<List<Opportunity>> getOpportunitiesByCategory(String category) =>
      (select(opportunities)..where((tbl) => tbl.category.equals(category))).get();

  Future<void> replaceOpportunities(List<OpportunitiesCompanion> entries) async {
    await batch((b) {
      b.deleteAll(opportunities);
      b.insertAll(opportunities, entries);
    });
  }
}

