import 'package:drift/drift.dart';

/// Drift table definition for offline caching of student profiles.
/// Sensitive fields (caste, income) are stored locally in the secure app sandbox.
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get age => integer().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get incomeBracket => text().nullable()();
  TextColumn get casteCategory => text().nullable()();
  TextColumn get curriculum => text().nullable()();
  TextColumn get skills => text().nullable()();
  TextColumn get subjects => text().nullable()();
  TextColumn get interests => text().nullable()();
  TextColumn get aspirations => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get preferredLanguage => text().nullable()();
  BoolColumn get isFirstGenLearner => boolean().nullable()();
  BoolColumn get hasFormalCurriculum => boolean().nullable()();
  TextColumn get board => text().nullable()();
  TextColumn get grade => text().nullable()();
  TextColumn get marks => text().nullable()();
  TextColumn get unstructuredLearning => text().nullable()();
  BoolColumn get isPendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

