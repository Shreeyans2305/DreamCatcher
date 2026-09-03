import 'package:drift/drift.dart';

/// Drift table definition for offline caching of opportunities (scholarships, exams, pathways, courses).
class Opportunities extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get provider => text()();
  TextColumn get description => text()();
  TextColumn get eligibility => text()();
  TextColumn get deadline => text().nullable()();
  TextColumn get url => text().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
