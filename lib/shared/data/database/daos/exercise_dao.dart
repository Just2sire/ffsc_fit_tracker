import "package:drift/drift.dart";

import "../../../domain/enums/equipment.dart";
import "../../../domain/enums/muscle_group.dart";
import "../app_database.dart";
import "../tables/exercises_table.dart";

part "exercise_dao.g.dart";

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  Future<Exercise?> getExerciseById(String id) {
    return (select(
      exercises,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Exercise>> getAllExercises() {
    return (select(exercises)
          ..where((tbl) => tbl.isArchived.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

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

  Future<List<Exercise>> filterExercises({
    MuscleGroup? muscle,
    Equipment? equipment,
  }) {
    final query = select(exercises)
      ..where((tbl) => tbl.isArchived.equals(false));
    if (muscle != null) {
      query.where((tbl) => tbl.muscleGroup.equalsValue(muscle));
    }
    if (equipment != null) {
      query.where((tbl) => tbl.equipment.equalsValue(equipment));
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.get();
  }

  Future<void> insertBatch(List<Exercise> rows) {
    return batch(
      (b) => b.insertAll(
        exercises,
        rows.map((row) => row.toCompanion(true)),
        mode: InsertMode.insertOrIgnore,
      ),
    );
  }

  Future<void> softDelete(String id) {
    return (update(exercises)..where((tbl) => tbl.id.equals(id))).write(
      ExercisesCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
