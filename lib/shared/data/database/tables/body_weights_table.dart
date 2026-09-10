import "package:drift/drift.dart";

/// Une pesée de l'utilisateur, datée. Table indépendante, sans FK.
class BodyWeights extends Table {
  TextColumn get id => text()();

  RealColumn get weightKg => real()();

  DateTimeColumn get recordedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
