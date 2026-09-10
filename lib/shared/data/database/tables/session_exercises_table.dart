import "package:drift/drift.dart";

import "../../../domain/enums/equipment.dart";
import "../../../domain/enums/muscle_group.dart";
import "exercises_table.dart";
import "workout_sessions_table.dart";

/// Un exercice tel que réalisé dans une séance précise.
///
/// Porte des snapshots figés au moment du log : si l'exercice source est
/// modifié ou archivé plus tard, l'historique de cette séance reste inchangé.
class SessionExercises extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();

  TextColumn get exerciseId => text().references(Exercises, #id)();

  TextColumn get exerciseNameSnapshot => text()();

  TextColumn get equipmentSnapshot => textEnum<Equipment>()();

  /// Snapshot du muscle principal (`Exercise.muscleGroup`, basé sur `target`).
  TextColumn get primaryMuscleSnapshot => textEnum<MuscleGroup>()();

  /// Position de l'exercice dans la séance (ordre de navigation).
  IntColumn get sortOrder => integer()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
