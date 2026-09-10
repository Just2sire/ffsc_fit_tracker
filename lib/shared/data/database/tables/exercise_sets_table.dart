import "package:drift/drift.dart";

import "session_exercises_table.dart";

/// Une série individuelle (poids × reps) validée pendant une séance.
///
/// Seule table sans `createdAt`/`updatedAt` — elle porte `completedAt` à la
/// place, renseigné uniquement au moment de la validation de la série.
class ExerciseSets extends Table {
  TextColumn get id => text()();

  TextColumn get sessionExerciseId => text().references(
    SessionExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// Position de la série dans l'exercice (1, 2, 3...).
  IntColumn get setNumber => integer()();

  RealColumn get weight => real()();

  IntColumn get reps => integer()();

  /// Fourchette de reps cible héritée du programme (ex: "8-10"), texte libre
  /// car elle peut représenter une plage plutôt qu'un nombre unique.
  TextColumn get targetReps => text().nullable()();

  RealColumn get targetWeight => real().nullable()();

  /// Effort perçu (1-10).
  IntColumn get rpe => integer().nullable()();

  TextColumn get notes => text().nullable()();

  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();

  /// Horodatage de validation de la série — `null` tant qu'elle n'est pas
  /// encore validée.
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
