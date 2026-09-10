import "package:drift/drift.dart";

import "exercises_table.dart";
import "workout_days_table.dart";

/// Un exercice planifié dans un jour de programme, avec ses objectifs
/// (séries/reps/repos). Réordonnable par glisser-déposer via [sortOrder].
class ProgramExercises extends Table {
  TextColumn get id => text()();

  TextColumn get workoutDayId => text().references(WorkoutDays, #id)();

  TextColumn get exerciseId => text().references(Exercises, #id)();

  /// Position de l'exercice dans le jour (0, 1, 2...), modifiée par le
  /// `ReorderableListView` de M-05.
  IntColumn get sortOrder => integer()();

  IntColumn get targetSets => integer()();

  /// Fourchette de répétitions cible (ex: 8 à 10) — utilisée par le
  /// `ProgressionEngine` pour scorer SUCCESS/PARTIAL/FAILURE.
  IntColumn get targetRepsMin => integer()();

  IntColumn get targetRepsMax => integer()();

  /// Temps de repos entre les séries, en secondes.
  IntColumn get restTimeSeconds => integer()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
