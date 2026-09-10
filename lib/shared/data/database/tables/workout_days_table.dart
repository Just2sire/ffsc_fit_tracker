import "package:drift/drift.dart";

import "workout_programs_table.dart";

/// Un jour d'entraînement dans un programme (ex: "Jour Push").
///
/// Soft delete uniquement, comme [WorkoutPrograms] — un jour supprimé doit
/// rester lisible dans l'historique des séances passées.
class WorkoutDays extends Table {
  TextColumn get id => text()();

  TextColumn get programId => text().references(WorkoutPrograms, #id)();

  TextColumn get name => text()();

  /// Position du jour dans le programme (0, 1, 2...) — utilisée pour la
  /// logique du "prochain jour suggéré" et l'affichage ordonné.
  IntColumn get dayOrder => integer()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
