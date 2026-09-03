import 'package:drift/drift.dart';

/// Drift table definition for auto-saving onboarding draft progress and offline sync queuing.
@DataClassName('OnboardingDraftData')
class OnboardingDrafts extends Table {
  TextColumn get userId => text()();
  IntColumn get currentStep => integer().withDefault(const Constant(0))();
  TextColumn get draftJson => text()();
  BoolColumn get isPendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}
