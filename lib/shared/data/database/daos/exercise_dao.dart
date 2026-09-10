import "package:drift/drift.dart";

import "../../../domain/enums/muscle_group.dart";
import "../app_database.dart";
import "../tables/exercises_table.dart";

part "exercise_dao.g.dart";

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Exercices actifs (non archivés), triés par nom.
  Future<List<Exercise>> getAllExercises() {
    return (select(exercises)
          ..where((tbl) => tbl.isArchived.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  /// Recherche par nom sur les exercices actifs (V1 : nom uniquement, pas
  /// les instructions).
  Future<List<Exercise>> searchExercises(String query) {
    final pattern = "%${query.toLowerCase()}%";
    return (select(exercises)
          ..where(
            (tbl) =>
                tbl.isArchived.equals(false) & tbl.name.lower().like(pattern),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  /// Exercices actifs dont le muscle principal (`target`) correspond.
  Future<List<Exercise>> filterByMuscle(MuscleGroup muscle) {
    return (select(exercises)..where(
          (tbl) =>
              tbl.isArchived.equals(false) &
              tbl.muscleGroup.equalsValue(muscle),
        ))
        .get();
  }

  /// Insertion en lot au seed initial. `insertOrIgnore` rend l'opération
  /// idempotente si jamais elle est rejouée (même `id`).
  Future<void> insertBatch(List<Exercise> rows) {
    return batch(
      (b) => b.insertAll(
        exercises,
        rows.map((row) => row.toCompanion(true)),
        mode: InsertMode.insertOrIgnore,
      ),
    );
  }

  /// Archive un exercice — jamais de `DELETE` réel sur cette table.
  Future<void> softDelete(String id) {
    return (update(exercises)..where((tbl) => tbl.id.equals(id))).write(
      ExercisesCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
